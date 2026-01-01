module Muwu
  module RenderHtmlPartial
    class Topic


      include Muwu

      require 'commonmarker'
      require 'nokogiri'


      attr_accessor(
        :commonmarker_options,
        :depth,
        :destination,
        :distinct,
        :does_have_source_text,
        :end_links,
        :generate_inner_identifiers,
        :heading,
        :heading_origin,
        :html_id,
        :id,
        :is_parent_heading,
        :numbering,
        :numbering_as_text,
        :project,
        :source_filename_absolute,
        :source_filename_relative,
        :source_relative_segments,
        :subsections_are_distinct,
        :subtopics,
        :text_root_name,
        # :text_root_name_id,
        :will_render_section_number
      )


      def render
        @destination.padding_vertical(1) do
          write_tag_section_open
          render_section_number
          render_heading
          render_text
          if (@is_parent_heading == true) && (@subsections_are_distinct == true)
            render_end_links
            render_subtopics
          elsif (@is_parent_heading == true) && (@subsections_are_distinct == false)
            render_subtopics
            render_end_links
          elsif (@is_parent_heading == false)
            render_end_links
          end
          write_tag_section_close
        end
      end


      def render_end_links
        if @end_links && @end_links.any?
          write_tag_nav_open
          @end_links.each_pair do |name, href|
            render_end_link(name, href)
          end
          write_tag_nav_close
        end
      end


      def render_end_link(name, href)
        write_tag_nav_a(name, href)
      end


      def render_heading
        if heading_origin_is_basename_or_outline
          write_tag_heading
        end
      end


      def render_section_number
        if @will_render_section_number
          write_tag_span_section_number
        end
      end


      def render_subtopics
        @destination.padding_vertical(1) do
          @subtopics.each do |subtopic|
            subtopic.render
          end
        end
      end


      def render_text
        if (source_file_exists == true)
          write_text_source_to_html
        end
      end


      def write_tag_heading
        @destination.write_line tag_heading
      end


      def write_tag_nav_a(name, href)
        @destination.write_line tag_nav_a(name, href)
      end


      def write_tag_nav_close
        @destination.write_line tag_nav_close
      end


      def write_tag_nav_open
        @destination.write_line tag_nav_end_links_open
      end


      def write_tag_section_open
        @destination.write_line tag_section_open
      end


      def write_tag_section_close
        @destination.write_line tag_section_close
      end


      def write_tag_span_section_number
        @destination.write_line tag_span_section_number
      end


      def write_text_file_missing
        @destination.write_line tag_div_file_missing
      end


      def write_text_source_to_html
        @destination.write_inline source_to_html
      end


      private


      def heading_origin_is_basename_or_outline
        [:basename, :outline].include?(@heading_origin)
      end


      def source_file_exists
        if @source_filename_absolute
          File.exist?(@source_filename_absolute)
        end
      end


      def source_to_html
        case File.extname(@source_filename_absolute).downcase
        when '.md'
          source_to_html_from_md
        end
      end


      def source_to_html_from_md
        fragment = Nokogiri::HTML5.fragment(source_md_to_html)
        fragment.css('a.anchor[aria-hidden]').each { |node| node.remove }

        starting_heading = nil
        if fragment.children.any? && fragment.children.first.name =~ /\Ah\d{1}\z/i
          starting_heading = fragment.first_element_child.remove
          starting_heading['data-topic'] = 'section-heading'
          starting_heading['data-depth'] = @depth
        end

        if @generate_inner_identifiers
          %w(blockquote dd dl dt h1 h2 h3 h4 h5 h6 li ol p pre table td tr ul).each do |element|
            fragment.css(element).each do |node|
              data_source_class = []
              @source_relative_segments.each_index do |i|
                data_source_class << "#{source_relative_segments[i]}-#{node.name}"
              end
              node['data-topic-source-class'] = data_source_class.join(' ')
              node['data-topic-id-class'] = "#{id}-#{node.name}"
            end
          end
        end

        if starting_heading
          fragment.children.first.previous = starting_heading
        end
        fragment.to_html
      end


      def source_md_to_html
        Commonmarker.to_html(File.read(@source_filename_absolute), options: @commonmarker_options, plugins: { syntax_highligher: nil })
      end


      def tag_nav_a(name, href)
        "<a data-topic='navigation-link' href='#{href}'>[#{name}]</a>"
      end


      def tag_nav_close
        "</nav>"
      end


      def tag_nav_open
        "<nav>"
      end


      def tag_nav_end_links_open
        "<nav data-topic='navigation'>"
      end


      def tag_div_file_missing
        "<div class='compiler_warning file_missing'>#{@source_filename_relative}</div>"
      end


      def tag_heading
        "<div data-topic='section-heading' data-depth='#{@depth}'>#{@heading}</div>"
      end


      def tag_section_close
        "</section>"
      end


      def tag_section_open
        "<section data-document-block='topic' data-topic-depth='#{@depth}' data-section-number='#{@numbering_as_text}' data-source='#{@source_filename_relative}' id='#{@html_id}'>"
      end


      def tag_span_file_missing
        "<span class='compiler_warning file_missing'>#{@source_filename_relative}</span>"
      end


      def tag_span_section_number
        "<div data-topic='section-number' data-depth='#{@depth}'>#{@numbering_as_text}</div>"
      end


    end
  end
end
