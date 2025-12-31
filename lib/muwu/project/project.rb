module Muwu
  class Project


    include Muwu
    include Helper


    attr_accessor(
      :exceptions,
      :instance_date,
      :javascript_libraries_requested,
      :manifest,
      :metadata,
      :options,
      :outline,
      :slug,
      :working_directory
    )


    def initialize
      @exceptions = []
      @instance_date = Time.now.strftime('%Y-%m-%d')
      @metadata = {}
      @outline = []
    end


    public


    def css_manifest_file_does_exist
      File.exist?(css_manifest_filename) == true
    end


    def css_manifest_filename
      File.absolute_path(File.join(path_css, 'index.scss'))
    end


    def css_basename
      if @options.output_file_css_basename.to_s == ''
        SanitizerHelper::sanitize_destination_file_basename(slug).downcase
      else
        SanitizerHelper::sanitize_destination_file_basename(@options.output_file_css_basename).downcase
      end
    end


    def default_text_block_name
      Default::PROJECT_OUTLINE[:default_text_block_name]
    end


    def does_not_have_crucial_files
      metadata_file_does_not_exist &&
      options_file_does_not_exist &&
      outline_file_does_not_exist
    end


    def exceptions_add(exception)
      @exceptions << exception
    end


    def exceptions_fatal
      @exceptions.select{ |e| e.type == :fatal }
    end


    def exceptions_include?(exception)
      @exceptions.map{ |e| e.class }.include?(exception)
    end


    def has_multiple_html_documents
      @manifest.documents_html_count > 1
    end


    def html_basename
      if @options.output_file_html_basename.to_s == ''
        SanitizerHelper::sanitize_destination_file_basename('index').downcase
      else
        SanitizerHelper::sanitize_destination_file_basename(@options.output_file_html_basename).downcase
      end
    end


    def inspect
      ["#{self.to_s}", "{", inspect_instance_variables, "}"].join(' ')
    end


    def inspect_instance_variables
      self.instance_variables.map { |v| "#{v}=#<#{instance_variable_get(v).class}>" }.join(", ")
    end


    def js_basename
      if @options.output_file_js_basename.to_s == ''
        SanitizerHelper::sanitize_destination_file_basename(slug).downcase
      else
        SanitizerHelper::sanitize_destination_file_basename(@options.output_file_js_basename).downcase
      end
    end


    def metadata_file_does_exist
      File.exist?(metadata_filename) == true
    end


    def metadata_file_does_not_exist
      File.exist?(metadata_filename) == false
    end


    def metadata_filename
      determine_project_asset_filepath(:metadata)
    end


    def options_file_does_exist
      File.exist?(options_filename) == true
    end


    def options_file_does_not_exist
      File.exist?(options_filename) == false
    end


    def options_filename
      determine_project_asset_filepath(:options)
    end


    def outline_file_does_exist
      File.exist?(outline_filename) == true
    end


    def outline_file_does_not_exist
      File.exist?(outline_filename) == false
    end


    def outline_filename
      determine_project_asset_filepath(:outline)
    end


    def outline_has_more_than_one_document
      outline_length > 1
    end


    def outline_has_only_one_document
      outline_length == 1
    end


    def outline_length
      outline.length
    end


    def outline_text_block_names
      result = []
      outline_text_blocks.each do |text_block|
        text_block_name = determine_text_block_name(text_block)
        if text_block_name == ''
          result << 'main'
        else
          result << text_block_name
        end
      end
      result.uniq
    end


    def outline_text_blocks
      @outline.flatten.select { |outline_step| (Hash === outline_step) && (RegexpLib.outline_text =~ outline_step.flatten[0]) }
    end


    def outline_text_blocks_named(text_root_name)
      result = []
      outline_text_blocks.each do |text_block|
        text_block_name = determine_text_block_name(text_block)
        if text_block_name == text_root_name.downcase
          result.concat(text_block.flatten[1])
        end
      end
      result
    end


    def outline_text_pathnames
      @options.outline_text_pathnames
    end


    def outline_text_pathnames_are_explicit
      @options.outline_text_pathnames == 'explicit'
    end


    def outline_text_pathnames_are_flexible
      @options.outline_text_pathnames == 'flexible'
    end


    def outline_text_pathnames_are_implicit
      @options.outline_text_pathnames == 'implicit'
    end


    def outlined_documents
      @outline
    end


    def outlined_documents_by_index
      result = {}
      @outline.each_index do |index|
        result[index] = @outline[index]
      end
      result
    end


    def output_destination
      @options.output_destination
    end


    def output_destination_requests_stdout
      @options.output_destination == 'stdout'
    end


    def output_formats_several
      @options.output_formats.length > 1
    end



    # TODO: Move path definitions into Muwu::Default::FILEPATHS

    def path_compiled
      File.absolute_path(File.join(@working_directory, 'compiled'))
    end


    def path_compiled_does_exist
      Dir.exist?(path_compiled)
    end


    def path_config
      File.absolute_path(File.join(@working_directory, 'config'))
    end


    def path_css
      File.absolute_path(File.join(path_config, 'css'))
    end


    def path_css_base
      File.absolute_path(File.join(path_css, 'base'))
    end


    def path_css_colors
      File.absolute_path(File.join(path_css, 'colors'))
    end


    def path_css_extensions
      File.absolute_path(File.join(path_css, 'extensions'))
    end


    def path_outline
      @working_directory
    end


    def path_text
      File.absolute_path(File.join(@working_directory, 'text'))
    end


    def slug
      if @metadata.has_key?('slug')
        @metadata['slug']
      else
        working_directory_name
      end
    end


    def sort_outline_text_blocks
      result = []
      outline_text_blocks.each do |text_block|
        text_block_name = determine_text_block_name(text_block)
        text_block_contents = determine_text_block_contents(text_block)
        existing_block = result.select { |b| b.has_key?(text_block_name) }.flatten
        if existing_block.empty?
          result << { text_block_name => text_block_contents }
        else
          existing_block[text_block_name].concat(text_block_contents)
        end
      end
      result
    end


    def text_block_naming_is_simple
      outline_text_block_names == [default_text_block_name]
    end


    def text_block_naming_is_not_simple
      text_block_naming_is_simple == false
    end


    def title
      if @metadata.has_key?('title')
        @metadata['title']
      else
        working_directory_name
      end
    end


    def will_create_css_file
      @options.output_formats.include?('css')
    end


    def will_create_html_file_only
      @options.output_formats == ['html']
    end


    def will_create_javascript_file
      if will_require_javascript_libraries
        @options.output_formats.include?('js')
      end
    end


    def will_require_javascript_libraries
      @javascript_libraries_requested.count > 0
    end


    def will_embed_at_least_one_asset
      will_embed_css || will_embed_js
    end


    # TODO: What if there's no css to embed?
    # Consider redefining this method.
    def will_embed_css
      will_create_css_file == false
    end


    # TODO: What if there's no js to embed?
    # Consider redefining this method.
    def will_embed_js
      will_create_javascript_file == false
    end


    def will_generate_navigators_automatically
      (outline_has_more_than_one_document) && (@options.generate_navigators_automatically == true) && (@options.output_destination == 'file')
    end


    def will_generate_subcontents_automatically
      (outline_has_more_than_one_document) && (@options.generate_subcontents_automatically == true)
    end


    def will_render_section_numbers
      @options.render_section_numbers == true
    end


    def will_not_generate_navigators_automatically
      not will_generate_navigators_automatically
    end


    def will_not_generate_subcontents_automatically
      not will_generate_subcontents_automatically
    end


    def working_directory_name
      @working_directory.split(File::SEPARATOR)[-1]
    end



    private


    def determine_project_asset_filepath(type)
      File.absolute_path(File.join(@working_directory, Default::FILEPATHS[type], Default::FILENAMES[type]))
    end


    def determine_text_block_contents(text_block)
      text_block.flatten[1]
    end


    def determine_text_block_name(text_block)
      directive = text_block.flatten[0]
      components = directive.partition(RegexpLib.outline_text_plus_whitespace)
      text_block_name = components[2].to_s.downcase.strip
      if text_block_name == ''
        text_block_name = default_text_block_name
      end
      text_block_name
    end


  end
end
