module Muwu
  module ManifestTask
    class DocumentHtml


      attr_accessor(
        :destination,
        :css_filename,
        :css_include_method,
        # :filename,
        :index,
        :js_filename,
        :js_include_method,
        :js_head_libraries,
        :project,
        :tasks
      )


      def inspect
        ["#{self.to_s}", "{", inspect_instance_variables, "}"].join(' ')
      end


      def inspect_instance_variables
        self.instance_variables.map { |v| "#{v}=#<#{instance_variable_get(v).class}>" }.join(", ")
      end


      public


      def contents_blocks
        @tasks.select { |task| ManifestTask::Contents === task }
      end


      def contents_blocks_by_name(text_root_name)
        contents_blocks.select { |task| task.text_root_name.downcase == text_root_name.downcase }
      end


      def filename
        @destination.output_filename
      end


      def text_blocks
        @tasks.select { |task| ManifestTask::Text === task }
      end


      def text_blocks_by_name(text_root_name)
        text_blocks.select { |task| task.text_root_name.strip.downcase == text_root_name.strip.downcase }
      end


      def will_generate_subcontents_automatically
        if @project.options.generate_subcontents_automatically
          return text_blocks.any? && contents_blocks.empty?
        else
          return false
        end
      end



      public



    end
  end
end
