module Muwu
  module RenderHtmlPartialBuilder
    class SubcontentsBuilder


      include Muwu


      attr_accessor(
        :project,
        :renderer,
        :task_subcontents,
        :text_root_name
      )


      def self.build
        builder = new
        yield(builder)
        builder.renderer
      end


      def initialize
        @renderer = RenderHtmlPartial::Subcontents.new
      end


      def build_from_manifest_task_subcontents(task_subcontents)
        @project = task_subcontents.project
        @task_subcontents = task_subcontents
        @text_root_name = task_subcontents.text_root_name
        set_destination
        set_html_attr_id
        set_item_depth_max
        set_project
        set_text_root_blocks
        set_will_render_section_numbers
      end


      def set_destination
        @renderer.destination = @task_subcontents.destination
      end


      def set_html_attr_id
        @renderer.html_attr_id = 'subcontents'
      end


      def set_item_depth_max
        @renderer.item_depth_max = @project.options.render_sections_distinctly_depth_max
      end


      def set_project
        @renderer.project = @project
      end


      def set_text_root_blocks
        @renderer.text_root_blocks = @task_subcontents.text_root_blocks
      end


      def set_text_root_name
        @renderer.text_root_name = @text_root_name
      end


      def set_will_render_section_numbers
        @renderer.will_render_section_numbers = @project.options.render_section_numbers
      end


    end
  end
end
