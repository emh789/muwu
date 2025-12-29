module Muwu
  module ManifestTaskBuilders
    class TopicBuilder


      include Muwu
      include Helper


      @@topic_id = 0


      attr_accessor(
        :heading_data,
        :numbering,
        :outline_fragment,
        :parent_manifest_text,
        :project,
        :source_filename,
        :topic
      )


      def self.build
        builder = new
        yield(builder)
        builder.topic
      end


      def initialize
        @topic = ManifestTask::Topic.new
      end


      def build_from_outline_fragment_text(outline_fragment, numbering, parent_manifest_text)
        @numbering = numbering
        @outline_fragment = outline_fragment
        @parent_manifest_text = parent_manifest_text
        @project = parent_manifest_text.project
        phase_1_set_id
        phase_1_set_project
        phase_2_set_source_filename
        phase_3_set_heading
        phase_4_set_destination
        phase_4_set_naming
        phase_4_set_numbering
        phase_5_set_subtopics
        phase_6_validate_file_presence
      end


      def phase_1_set_id
        @topic.id = @@topic_id
        @@topic_id = @@topic_id + 1
      end


      def phase_1_set_project
        @topic.project = @project
      end


      def phase_2_set_source_filename
        @source_filename = determine_source_filename
        @topic.source_filename = @source_filename
      end


      def phase_3_set_heading
        @heading_data = determine_heading_data
        @topic.heading = @heading_data[:heading]
        @topic.heading_origin = @heading_data[:origin]
      end


      def phase_4_set_destination
        @topic.destination = @parent_manifest_text.destination
      end


      def phase_4_set_naming
        if Hash === @outline_fragment
          @topic.naming = [@parent_manifest_text.naming, SanitizerHelper.sanitize_topic_path(outline_step)].flatten
        else
          @topic.naming = [@parent_manifest_text.naming, @heading_data[:heading]].flatten
        end
      end


      def phase_4_set_numbering
        @topic.numbering = @numbering
      end


      def phase_5_set_subtopics
        if Hash === @outline_fragment
          @topic.subtopics = determine_subtopics
        end
      end


      def phase_6_validate_file_presence
        ProjectValidator.new(@project).validate_task_topic(@topic)
      end



      private


      def build_topic(step, section_numbering)
        ManifestTaskBuilders::TopicBuilder.build do |b|
          b.build_from_outline_fragment_text(step, section_numbering, @topic)
        end
      end


      def determine_child_steps_from_outline
        [@outline_step.flatten[1]].flatten
      end


      def determine_subtopics
        subtopics = []
        child_steps = [@outline_fragment.flatten[1]].flatten
        if child_steps.empty? == false
          child_section_numbering = section_number_extend(@topic.numbering)
          child_steps.each do |step|
            child_section_numbering = section_number_increment(child_section_numbering)
            subtopics << build_topic(step, child_section_numbering)
          end
        end
        subtopics
      end


      def determine_source_filename
        if @project.outline_text_pathnames_are_explicit
          determine_source_filename_explicitly
        elsif @project.outline_text_pathnames_are_flexible
          determine_source_filename_flexibly
        elsif @project.outline_text_pathnames_are_implicit
          determine_source_filename_implicitly
        else
          determine_source_filename_explicitly
        end
      end


      def determine_source_filename_explicitly
        filename = SanitizerHelper.sanitize_topic_basename(outline_step)
        filepath = ['text']
        File.join([filepath, filename].flatten)
      end


      def determine_source_filename_flexibly
        if OutlineHelper.new(outline_step).text_step_flexible_suggests_file
          determine_source_filename_explicitly
        else
          determine_source_filename_implicitly
        end
      end


      def determine_source_filename_implicitly
        source_filename = ''
        file_path = make_filepath_implicitly
        file_basename = SanitizerHelper.sanitize_topic_path(outline_step)
        file_name_md = file_basename + '.md'
        source_filename = File.join([file_path, file_name_md].flatten)
        source_filename
      end


      def determine_heading_data
        if @topic.source_file_does_exist
          determine_heading_from_file
        elsif @topic.source_file_does_not_exist
          determine_heading_from_file_basename_or_outline
        end
      end


      def determine_heading_from_file
        case File.extname(@topic.source_filename_absolute).downcase
        when '.md'
          determine_heading_from_file_md
        else
          determine_heading_from_file_basename
        end
      end


      def determine_heading_from_file_basename
        heading = File.basename(@topic.source_filename, '.*')
        origin = :basename
        { heading: heading, origin: origin }
      end


      def determine_heading_from_file_basename_or_outline
        case @project.outline_text_pathnames
        when 'explicit'
          heading = File.basename(@topic.source_filename, '.*')
          origin = :basename
        when 'flexible', 'implicit'
          heading = outline_step
          origin = :outline
        else
          heading = ''
          origin = nil
        end
        { heading: heading, origin: origin }
      end


      def determine_heading_from_file_md
        first_line = File.open(@topic.source_filename_absolute, 'r') { |f| f.gets("\n").to_s }
        if first_line =~ RegexpLib.markdown_heading
          determine_heading_from_file_md_first_line(first_line)
        else
          determine_heading_from_file_basename_or_outline
        end
      end


      def determine_heading_from_file_md_first_line(first_line)
        heading = first_line.gsub(RegexpLib.markdown_heading_plus_whitespace,'').strip
        origin = :text_source
        { heading: heading, origin: origin }
      end


      def make_filepath_implicitly
        path_from_project_home = ['text']
        if @project.text_block_naming_is_simple
          path_from_project_home.concat(@parent_manifest_text.naming_downcase_without_text_root)
        elsif @project.text_block_naming_is_not_simple
          path_from_project_home.concat(@parent_manifest_text.naming_downcase)
        end
        safe_path_from_project_home = SanitizerHelper.sanitize_topic_path(path_from_project_home)
        safe_path_from_project_home
      end


      def outline_step
        case @outline_fragment
        when Hash
          @outline_fragment.flatten[0].to_s
        else
          @outline_fragment.to_s
        end
      end


      def outline_step_sanitized
        SanitizerHelper.sanitize_topic_path(outline_step)
      end


      def section_number_extend(number_incoming)
        number_outgoing = number_incoming.clone
        number_outgoing << 0
        number_outgoing
      end


      def section_number_increment(number_incoming)
        number_outgoing = number_incoming.clone
        number_outgoing[-1] = number_outgoing[-1].next
        number_outgoing
      end



    end
  end
end
