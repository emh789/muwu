module Muwu
  class ProjectOptions


    attr_accessor(
      :generate_navigators_automatically,
      :generate_subcontents_automatically,
      :generate_topic_inner_identifiers,
      :html_head_includes_metadata_tags,
      :html_lang,
      :html_uses_javascript_navigation,
      :markdown_allows_raw_html,
      :outline_text_pathnames,
      :output_destination,
      :output_file_css_basename,
      :output_file_html_basename,
      :output_file_js_basename,
      :output_formats,
      :remote_publish,
      :remote_sync,
      :render_punctuation_smart,
      :render_section_end_links,
      :render_section_numbers,
      :render_sections_distinctly_depth_max,
      :render_title_section_metadata,
      :rsync_options,
      :warning_if_parent_heading_lacks_source
    )


    def initialize
      Default::PROJECT_OPTIONS.each_pair do |key, value|
        set_option(key, value)
      end
    end


    def inspect
      ["#{self.to_s}", "{", inspect_instance_variables, "}"].join(' ')
    end


    def inspect_instance_variables
      instance_variables.map { |v| "#{v}=#{instance_variable_get(v).inspect}" }.join(", ")
    end


    public


    def set_option(key, value)
      if Default::PROJECT_OPTIONS.has_key?(key)
        key_ivsym = "@#{key.to_s}"
        instance_variable_set(key_ivsym, value)
      end
    end


  end
end
