module Muwu
  class ProjectOptionValidatorValue


    require 'iso-639'

    include Muwu
    include Helper


    attr_accessor(
      :key_validated,
      :project,
      :validation_method_name,
      :value_provided
    )


    def initialize(key_validated, value_provided, project)
      @key_validated = key_validated.to_s.gsub(/\W/,'_')
      @project = project
      @validation_method_name = "validate_option_#{@key_validated}"
      @value_provided = value_provided
    end


    public


    def validated_value
      if private_methods.include?(@validation_method_name.to_sym)
        return method(@validation_method_name).call
      else
        @project.exceptions_add ProjectException::OptionNotValidatable.new(@key_validated)
        return nil
      end
    end


    def value_as_array(value)
      result = []
      case value
      when String
        result = value.split(/,\s*/).map{ |v| value_as_string(v) }.sort
      when Array
        result = value.map{ |v| value_as_string(v) }.sort
      when FalseClass, TrueClass
        result << value
      end
      result.reject!{ |r| r == '' }
      result
    end


    def value_as_integer(value)
      value.to_i
    end


    def value_as_string(value)
      value.to_s.strip.downcase
    end


    def value_as_string_preserving_case(value)
      value.to_s.strip
    end


    def value_provided_as_array
      value_as_array(@value_provided)
    end


    def value_provided_as_integer
      value_as_integer(@value_provided)
    end


    def value_provided_as_string
      value_as_string(@value_provided)
    end


    def value_provided_as_string_preserving_case
      value_as_string_preserving_case(@value_provided)
    end


    private


    def validate_option_generate_navigators_automatically
      return validation_for_boolean
    end


    def validate_option_generate_subcontents_automatically
      return validation_for_boolean
    end


    def validate_option_generate_topic_inner_identifiers
      return validation_for_boolean
    end


    def validate_option_html_head_includes_metadata_tags
      return validation_for_boolean
    end


    def validate_option_html_lang
      case @value_provided
      when nil, 'nil'
        return nil
      else
        value = ISO_639.find(value_provided_as_string)
        if value
          return value.alpha2
        else
          @project.exceptions_add ProjectException::OptionValueNotUnderstood.new(@key_validated, @value_provided)
          return nil
        end
      end
    end


    def validate_option_html_uses_javascript_navigation
      return validation_for_boolean
    end


    def validate_option_markdown_allows_raw_html
      return validation_for_boolean
    end


    def validate_option_outline_text_pathnames
      value = value_provided_as_string
      case value
      when 'explicit', 'flexible', 'implicit'
        return value
      else
        @project.exceptions_add ProjectException::OptionValueNotUnderstood.new(@key_validated, @value_provided)
        return nil
      end
    end


    def validate_option_output_destination
      value = value_provided_as_string
      case value
      when 'file', 'stdout'
        return value
      else
        @project.exceptions_add ProjectException::OptionValueNotUnderstood.new(@key_validated, @value_provided)
        return nil
      end
    end


    def validate_option_output_file_css_basename
      return validation_for_output_file_basename
    end


    def validate_option_output_file_html_basename
      return validation_for_output_file_basename
    end


    def validate_option_output_file_js_basename
      return validation_for_output_file_basename
    end


    def validate_option_output_formats
      result = []
      value_provided_as_array.each do |value|
        case value
        when 'css', 'html', 'js'
          result << value
        else
          @project.exceptions_add ProjectException::OptionValueNotUnderstood.new(@key_validated, @value_provided)
        end
      end
      return result
    end


    def validate_option_remote_publish
      return value_provided_as_string_preserving_case
    end


    def validate_option_remote_sync
      return value_provided_as_string_preserving_case
    end


    def validate_option_render_punctuation_smart
      return validation_for_boolean
    end


    def validate_option_render_section_end_links
      result = []
      value_provided_as_array.each do |value|
        case value
        when false
          result << value
        when true
          result = ['contents','home','top']
        when 'contents', 'home', 'top'
          result << value
        else
          @project.exceptions_add ProjectException::OptionValueNotUnderstood.new(@key_validated, @value_provided)
        end
      end
      return result
    end


    def validate_option_render_section_numbers
      return validation_for_boolean
    end


    def validate_option_render_sections_distinctly_depth_max
      case @value_provided
      when false, nil, 0, '', 'nil'
        return nil
      when Integer
        return @value_provided
      else
        @project.exceptions_add ProjectException::OptionValueNotUnderstood.new(@key_validated, @value_provided)
        return nil
      end
    end


    def validate_option_render_title_section_metadata
      case @value_provided
      when nil, '', 'nil'
        return nil
      when Array
        return @value_provided
      when String
        return @value_provided.split(/,\s*/)
      else
        return [@value_provided.to_s].flatten
      end
    end


    def validate_option_render_punctuation_smart
      return validation_for_boolean
    end


    def validate_option_rsync_options
      return value_provided_as_array
    end


    def validate_option_warning_if_parent_heading_lacks_source
      return validation_for_boolean
    end


    def validation_for_boolean
      case @value_provided
      when false, true
        return @value_provided
      when nil, '', 'nil'
        return nil
      else
        @project.exceptions_add ProjectException::OptionValueNotUnderstood.new(@key_validated, @value_provided)
        return nil
      end
    end


    def validation_for_output_file_basename
      case @value_provided
      when String
        return SanitizerHelper.sanitize_destination_file_basename(File.basename(@value_provided))
      when nil
        return nil
      else
        @project.exceptions_add ProjectException::OptionValueNotUnderstood.new(@key_validated, @value_provided)
        return nil
      end
    end


  end
end
