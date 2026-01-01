module Muwu
  module Default

    FILENAMES = {
      css_manifest: 'index.scss',
      metadata: 'metadata.yml',
      options: 'options.yml',
      outline: 'outline.yml'
    }

    FILEPATHS = {
      compiled: './compiled',
      css: './config/css',
      metadata: '',
      options: '',
      outline: '',
      text: './text'
    }

    PROJECT_OPTIONS = {
      generate_navigators_automatically: true,
      generate_subcontents_automatically: false,
      generate_topic_inner_identifiers: false,
      html_head_includes_metadata_tags: true,
      html_lang: nil,
      html_uses_javascript_navigation: false,
      markdown_allows_raw_html: false,
      outline_text_pathnames: 'flexible',
      output_destination: 'file',
      output_file_css_basename: nil,
      output_file_html_basename: 'index',
      output_file_js_basename: nil,
      output_formats: ['html','css','js'],
      remote_publish: nil,
      remote_sync: nil,
      render_punctuation_smart: true,
      render_section_end_links: ['contents', 'top'],
      render_section_numbers: true,
      render_sections_distinctly_depth_max: nil,
      render_title_section_metadata: ['title', 'subtitle', 'author'],
      rsync_options: '--itemize-changes --recursive --verbose',
      warning_if_parent_heading_lacks_source: true
    }

    PROJECT_OUTLINE = {
      default_text_block_name: 'main'
    }

  end
end
