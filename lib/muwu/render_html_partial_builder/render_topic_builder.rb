module Muwu
  module RenderHtmlPartialBuilder
    class TopicBuilder


      include Muwu

      attr_accessor :renderer


      def self.build
        builder = new
        yield(builder)
        builder.renderer
      end


      def initialize
        @renderer = RenderHtmlPartial::Topic.new
      end


      def build_from_manifest_topic(manifest_topic)
        @manifest_topic = manifest_topic
        @project = manifest_topic.project
        phase_1_set_id
        phase_1_set_commonmarker_options
        phase_1_set_destination
        phase_1_set_generate_inner_identifiers
        phase_1_set_heading
        phase_1_set_heading_origin
        phase_1_set_numbering
        phase_1_set_depth
        phase_1_set_numbering_as_text
        phase_1_set_does_have_source_text
        phase_1_set_is_parent_heading
        phase_1_set_text_root_name
        phase_2_set_source_filename_absolute
        phase_2_set_source_filename_relative
        phase_3_set_subtopics
        phase_3_set_source_relative_segments
        phase_4_set_end_links
        phase_4_set_will_render_section_number
        phase_4_set_subsections_are_distinct
        phase_5_set_html_id
      end


      def phase_1_set_commonmarker_options
        @renderer.commonmarker_options = { extension: {}, render: {} }
        @renderer.commonmarker_options[:extension].merge!({ description_lists: true })
        if @project.options.render_punctuation_smart
          @renderer.commonmarker_options[:render].merge!({ smart: true })
        end
        if @project.options.markdown_allows_raw_html
          @renderer.commonmarker_options[:render].merge!({ unsafe: true })
        end
      end


      def phase_1_set_destination
        @renderer.destination = @manifest_topic.destination
      end


      def phase_1_set_does_have_source_text
        if @manifest_topic.source_file_does_exist
          @renderer.does_have_source_text = true
        elsif @manifest_topic.source_file_does_not_exist
          @renderer.does_have_source_text = false
        end
      end


      def phase_1_set_generate_inner_identifiers
        @renderer.generate_inner_identifiers = @project.options.generate_topic_inner_identifiers
      end


      def phase_1_set_heading
        @renderer.heading = @manifest_topic.heading
      end


      def phase_1_set_heading_origin
        @renderer.heading_origin = @manifest_topic.heading_origin
      end


      def phase_1_set_id
        @renderer.id = @manifest_topic.id
      end


      def phase_1_set_is_parent_heading
        @renderer.is_parent_heading = @manifest_topic.is_parent_heading
      end


      def phase_1_set_numbering
        @renderer.numbering = @manifest_topic.numbering
      end


      def phase_1_set_depth
        @renderer.depth = @manifest_topic.topic_depth
      end


      def phase_1_set_numbering_as_text
        @renderer.numbering_as_text = @manifest_topic.numbering.join('.')
      end


      def phase_1_set_text_root_name
        @renderer.text_root_name = @manifest_topic.text_root_name
      end


      def phase_2_set_source_filename_absolute
        if @manifest_topic.source_file_does_exist
          @renderer.source_filename_absolute = @manifest_topic.source_filename_absolute
        end
      end


      def phase_2_set_source_filename_relative
        if @manifest_topic.source_file_does_exist
          @renderer.source_filename_relative = @manifest_topic.source_filename_relative
        end
      end


      def phase_3_set_subtopics
        if @manifest_topic.does_have_subtopics
          @renderer.subtopics = determine_subtopics
        end
      end


      def phase_3_set_source_relative_segments
        segments = @manifest_topic.source_filename_relative.split('/')
        segments.last.gsub!(/\.[\w\.]*\z/,'')
        @renderer.source_relative_segments = segments
      end


      def phase_4_set_end_links
        if topic_should_have_end_links
          @renderer.end_links = determine_end_links
        end
      end


      def phase_4_set_will_render_section_number
        @renderer.will_render_section_number = determine_whether_topic_will_render_section_number
      end


      def phase_4_set_subsections_are_distinct
        @renderer.subsections_are_distinct = determine_whether_subsections_are_distinct
      end


      def phase_5_set_html_id
        @renderer.html_id = Helper::HrefHelper.id_topic_header(@manifest_topic)
      end


      private


      def build_renderer_topic(topic)
        RenderHtmlPartialBuilder::TopicBuilder.build do |b|
          b.build_from_manifest_topic(topic)
        end
      end


      def determine_end_links
        end_links = {}
        if @project.options.render_section_end_links
          @project.options.render_section_end_links.each do |link|
            end_links[link] = determine_end_links_href(link)
          end
        end
        end_links
      end


      def determine_end_links_href(link)
        case link
        when 'contents'
          Helper::HrefHelper.link_to_contents_item(@manifest_topic, from: :topic)
        when 'home'
          Helper::HrefHelper.link_to_project_home(@project)
        when 'top'
          Helper::HrefHelper.link_to_document_top
        end
      end


      def determine_subtopics
        subtopics = []
        @manifest_topic.subtopics.each do |subtopic|
          subtopics << build_renderer_topic(subtopic)
        end
        subtopics
      end


      def determine_whether_subsections_are_distinct
        if @manifest_topic.does_have_subtopics
          if @project.options.render_sections_distinctly_depth_max == nil
            return true
          elsif @renderer.depth < @project.options.render_sections_distinctly_depth_max
            return true
          elsif @renderer.depth >= @project.options.render_sections_distinctly_depth_max
            return false
          end
        end
      end


      def determine_whether_topic_will_render_section_number
        if @project.will_render_section_numbers && topic_should_be_distinct
          true
        end
      end


      def topic_should_be_distinct
        if @project.options.render_sections_distinctly_depth_max == nil
          return true
        elsif @renderer.depth <= @project.options.render_sections_distinctly_depth_max
          return true
        elsif @renderer.depth > @project.options.render_sections_distinctly_depth_max
          return false
        end
      end


      def topic_should_have_end_links
        if topic_should_be_distinct
          return topic_distinct_should_have_end_links
        else
          return false
        end
      end


      def topic_distinct_should_have_end_links
        if @renderer.is_parent_heading
          return topic_distinct_parent_should_have_end_links
        elsif @renderer.does_have_source_text
          return true
        end
      end


      def topic_distinct_parent_should_have_end_links
        if @renderer.does_have_source_text == true
          return true
        elsif @renderer.does_have_source_text == false
          return topic_distinct_parent_without_source_should_have_end_links
        end
      end


      def topic_distinct_parent_without_source_should_have_end_links
        if determine_whether_subsections_are_distinct == true
          return false
        elsif determine_whether_subsections_are_distinct == false
          return true
        end
      end


    end
  end
end
