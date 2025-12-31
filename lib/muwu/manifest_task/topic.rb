module Muwu
  module ManifestTask
    class Topic


      include Muwu


      attr_accessor(
        :destination,
        :heading,
        :heading_origin,
        :id,
        :naming,
        :numbering,
        :outline,
        :project,
        :source_filename,
        :subtopics,
      )


      def inspect
        ["#{self.to_s}", "{", inspect_instance_variables, "}"].join(' ')
      end


      def inspect_instance_variables
        self.instance_variables.map { |v| "#{v}=#<#{instance_variable_get(v).class}>" }.join(", ")
      end



      public


      def does_have_subtopics
        is_parent_heading && (@subtopics.length >= 1)
      end


      def is_not_parent_heading
        is_parent_heading == false
      end


      def is_parent_heading
        Array === @subtopics
      end


      def naming_downcase
        @naming.map {|n| n.downcase}
      end


      def naming_downcase_without_text_root
        naming_without_text_root.map {|n| n.downcase}
      end


      def naming_without_text_root
        @naming[1..-1]
      end


      def numbering_to_depth_max
        if @project.options.render_sections_distinctly_depth_max
          index_min = 0
          index_max = @project.options.render_sections_distinctly_depth_max - 1
          if index_max >= index_min
            @numbering[index_min..index_max]
          else
            @numbering
          end
        else
          @numbering
        end
      end


      def project_directory
        @project.working_directory
      end


      def topic_depth
        @numbering.length
      end


      def source
        File.read(source_filename_absolute)
      end


      def source_file_does_exist
        File.exist?(source_filename_absolute) == true
      end


      def source_file_does_not_exist
        File.exist?(source_filename_absolute) == false
      end


      def source_filename_absolute
        File.absolute_path(File.join(project_directory, source_filename))
      end


      def source_filename_relative
        source_filename
      end


      def text_root_name
        @naming[0]
      end


    end
  end
end
