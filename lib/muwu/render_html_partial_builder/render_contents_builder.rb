module Muwu
  module RenderHtmlPartialBuilder
    class ContentsBuilder


      include Muwu


      attr_accessor(
        :task_contents,
        :project,
        :renderer,
        :text_root_name
      )


      def self.build
        builder = new
        yield(builder)
        builder.renderer
      end


      def initialize
        @renderer = RenderHtmlPartial::Contents.new
      end


      def build_from_manifest_task_contents(task_contents)
        @project = task_contents.project
        @task_contents = task_contents
        @text_root_name = task_contents.text_root_name
        phase_1_set_text_root_name
        phase_2_set_destination
        phase_2_set_href_helper
        phase_2_set_html_attr_id
        phase_2_set_item_depth_max
        phase_2_set_project
        phase_2_set_topics
        phase_2_set_will_render_section_numbers
      end


      def phase_1_set_text_root_name
        @renderer.text_root_name = @text_root_name
      end


      def phase_2_set_destination
        @renderer.destination = @task_contents.destination
      end


      def phase_2_set_href_helper
        @renderer.href_helper = Helper::HtmlHrefHelper.new(@task_contents)
      end


      def phase_2_set_html_attr_id
        @renderer.html_attr_id = ['contents', @text_root_name].join('_')
      end


      def phase_2_set_item_depth_max
        @renderer.item_depth_max = @project.options.render_sections_distinctly_depth_max
      end


      def phase_2_set_project
        @renderer.project = @project
      end


      def phase_2_set_topics
        @renderer.topics = determine_topics
      end


      def phase_2_set_will_render_section_numbers
        @renderer.will_render_section_numbers = @project.options.render_section_numbers
      end



      private


      def determine_topics
        determine_text_root_blocks.map { |trb| trb.topics }.flatten
      end


      def determine_text_root_blocks
        @task_contents.text_blocks_by_name(@text_root_name)
      end


    end
  end
end
