module Muwu
  class ProjectOptionValidatorKey


    include Muwu


    def initialize(key_as_provided, value_as_provided, project)
      @project = project
      @key_as_provided = key_as_provided
      @value_as_provided = value_as_provided

      @key_validated = validate_key
      @value_validated = validate_value
    end


    public


    def validated_key
      @key_validated
    end


    def validated_value
      @value_validated
    end


    private


    def validate_key
      key = @key_as_provided.downcase.gsub(/\W/,'_').to_sym
      key_is_valid = Default::PROJECT_OPTIONS.keys.include?(key)
      if key_is_valid
        return key
      else
        @project.exceptions_add ProjectException::OptionKeyNotUnderstood.new(@key_as_provided)
        return false
      end
    end


    def validate_value
      if @key_validated
        ProjectOptionValidatorValue.new(@key_validated, @value_as_provided, @project).validated_value
      end
    end


  end
end
