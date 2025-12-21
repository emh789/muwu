module Muwu
  module RenderHtmlPartial
    class TextItem


      include Muwu

      require 'commonmarker'
      require 'haml'


      attr_accessor(
        :commonmarker_options,
        :destination,
        :distinct,
        :does_have_source_text,
        :end_links,
        :heading,
        :heading_origin,
        :html_attr_id,
        :is_parent_heading,
        :numbering,
        :project,
        :section_depth,
        :section_number_as_attr,
        :section_number_as_text,
        :sections,
        :source_filename_absolute,
        :source_filename_relative,
        :subsections_are_distinct,
        :text_root_name,
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
            render_sections
          elsif (@is_parent_heading == true) && (@subsections_are_distinct == false)
            render_sections
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


      def render_sections
        @destination.padding_vertical(1) do
          @sections.each do |section|
            section.render
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
        when '.haml'
          source_to_html_from_haml
        when '.md'
          source_to_html_from_md
        end
      end


      def source_to_html_from_haml
        Haml::Engine.new(File.read(@source_filename_absolute), {suppress_eval: true}).render
      end


      def source_to_html_from_md
        Commonmarker.to_html(File.read(@source_filename_absolute), options: @commonmarker_options, plugins: { syntax_highligher: nil })
      end


      def tag_nav_a(name, href)
        "<a class='document_link' href='#{href}'>[#{name}]</a>"
      end


      def tag_nav_close
        "</nav>"
      end


      def tag_nav_open
        "<nav>"
      end


      def tag_nav_end_links_open
        "<nav class='document_links'>"
      end


      def tag_div_file_missing
        "<div class='compiler_warning file_missing'>#{@source_filename_relative}</div>"
      end


      def tag_heading
        "<h1>#{@heading}</h1>"
      end


      def tag_section_close
        "</section>"
      end


      def tag_section_open
        "<section data-section_depth='#{@section_depth}' data-section_number='#{@section_number_as_text}' data-source='#{@source_filename_relative}' id='#{@html_attr_id}'>"
      end


      def tag_section_with_source_open
        "<section data-section_depth='#{@section_depth}' data-section_number='#{@section_number_as_text}' data-source='#{@source_filename_relative}' id='#{@html_attr_id}'>"
      end


      def tag_section_without_source_open
        "<section data-section_depth='#{@section_depth}' data-section_number='#{@section_number_as_text}' id='#{@html_attr_id}'>"
      end


      def tag_span_file_missing
        "<span class='compiler_warning file_missing'>#{@source_filename_relative}</span>"
      end


      def tag_span_section_number
        "<h1 class='section_number'>#{@section_number_as_text}</h1>"
      end


    end
  end
end
