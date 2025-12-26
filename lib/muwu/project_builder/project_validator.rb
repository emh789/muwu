module Muwu
  class ProjectValidator


    include Muwu


    def initialize(project)
      @project = project
    end



    public


    def validate_dir_compiled
      if @project.path_compiled_does_exist
        return true
      else
        @project.exceptions_add ProjectException::CompiledFolderNotFound.new(@project)
        return false
      end
    end


    def validate_file_css
      if @project.css_manifest_file_does_exist
        return true
      else
        @project.exceptions_add ProjectException::CssManifestFileNotFound.new(@project.css_manifest_filename)
        return false
      end
    end


    def validate_file_metadata
      if @project.metadata_file_does_exist
        return true
      else
        @project.exceptions_add ProjectException::MetadataFileNotFound.new(@project)
        return false
      end
    end


    def validate_file_options
      if @project.options_file_does_exist
        return true
      else
        @project.exceptions_add ProjectException::OptionsFileNotFound.new(@project)
        return false
      end
    end


    def validate_file_outline
      if @project.outline_file_does_exist
        return true
      else
        @project.exceptions_add ProjectException::OutlineFileNotFound.new(@project)
        return false
      end
    end


    def validate_option_remote_publish
      if @project.options.remote_publish.to_s == ''
        @project.exceptions_add ProjectException::OptionRemotePublishValueNil.new
      end
    end


    def validate_option_remote_sync
      if @project.options.remote_sync.to_s == ''
        @project.exceptions_add ProjectException::OptionRemoteSyncValueNil.new
      end
    end


    def validate_outline_step_navigator(index)
      validate_outline_step_navigator_if_single_document(index)
      return validate_outline_step_navigator_if_automatic(index)
    end


    def validate_outline_step_navigator_if_automatic(index)
      if @project.will_not_generate_navigators_automatically
        return true
      elsif @project.will_generate_navigators_automatically
        @project.exceptions_add ProjectException::NavigatorsWillBeGeneratedAutomatically.new(index)
        return false
      end
    end


    def validate_outline_step_navigator_if_single_document(index)
      if @project.outline_has_only_one_document
        @project.exceptions_add ProjectException::NavigatorNotRecommendedWithSingleDocument.new(index)
      end
    end


    def validate_outline_step_subcontents(index)
      if @project.will_not_generate_subcontents_automatically
        return true
      elsif @project.will_generate_subcontents_automatically
        @project.exceptions_add ProjectException::SubcontentsWillBeGeneratedAutomatically.new(@index)
        return false
      end
    end


    def validate_output_destination_and_formats
      if @project.output_destination_requests_stdout && @project.output_formats_several
        @project.exceptions_add ProjectException::MultipleFormatsRequestedWithStdout.new
      end
    end


    def validate_scenario_if_more_than_one_document
      if @project.outline_has_more_than_one_document && @project.output_destination_requests_stdout
        @project.exceptions_add ProjectException::MultipleDocumentsOutlinedWithStdout.new
      end
      if @project.outline_has_more_than_one_document && @project.will_embed_at_least_one_asset
        @project.exceptions_add ProjectException::DryOutputRecommendedWithMultipleDocuments.new
      end
    end


    def validate_task_metadata(task)
      values_missing = task.metadata.select { |k,v| v.to_s == ''}
      if values_missing.empty?
        return true
      else
        values_missing.each_pair { |k,v| @project.exceptions_add ProjectException::MetadataValueNotGiven.new(task, k) }
        return false
      end
    end


    def validate_task_topic(task)
      if task.is_parent_heading
        return validate_task_topic_parent_heading(task)
      elsif task.is_not_parent_heading
        return validate_task_topic_child_heading(task)
      end
    end


    def validate_task_topic_child_heading(task)
      if task.source_file_does_exist
        return true
      else
        @project.exceptions_add ProjectException::TopicSourceFileNotFound.new(task)
        return false
      end
    end


    def validate_task_topic_parent_heading(task)
      if task.source_file_does_exist
        return true
      else
        if @project.options.warning_if_parent_heading_lacks_source
          @project.exceptions_add ProjectException::TopicSourceFileNotFound.new(task)
          return false
        end
      end
    end



    def validate_task_title(task)
      return validate_task_metadata(task)
    end



  end
end
