module Muwu
  module RenderHtmlPartial
    class DocumentHtml


      include Muwu


      require 'sassc'


      attr_accessor(
        :destination,
        :head_css_filename,
        :head_css_method,
        :head_js_filename,
        :head_js_libraries,
        :head_js_method,
        :head_includes_metadata_tags,
        :head_metadata,
        :html_lang,
        :html_title,
        :project,
        :tasks
      )


      def initialize
        @head_metadata = {}
        @tasks = []
      end



      public



      def render
        @destination.output_stream do
          render_tag_html_open
          @destination.padding_vertical(1) do
            render_head
            render_body
          end
          write_tag_html_close
        end
      end


      def options
        @project.options
      end


      def render_body
        @destination.padding_vertical(1) do
          write_tag_body_open
          render_body_manifest_tasks
          write_tag_body_close
        end
      end


      def render_body_manifest_tasks
        @destination.padding_vertical(1) do
          @tasks.each do |task|
            task.render
          end
        end
      end


      def render_head
        @destination.padding_vertical(1) do
          write_tag_head_open
          @destination.margin_indent do
            write_tag_title
            render_head_meta_tags
            render_head_css
            render_head_js
          end
          write_tag_head_close
        end
      end


      def render_head_css
        case @head_css_method
        when :embed
          render_head_css_embed
        when :link
          render_head_css_link
        end
      end


      def render_head_css_embed
        write_tag_style_open
        write_css_if_manifest_exists
        write_tag_style_close
      end


      def render_head_css_link
        write_tag_link_stylesheet
      end


      def render_head_js
        case @head_js_method
        when :embed
          render_head_js_embed
        when :link
          render_head_js_link
        end
      end


      def render_head_js_embed
        write_tag_script_open
        @head_js_libraries.each do |library|
          write_js_library(library)
        end
        write_tag_script_close
      end


      def render_head_js_lib_navigation
        if @project.options.html_uses_javascript_navigation
          write_js_lib_navigation
        end
      end


      def render_head_js_link
        write_tag_script_src
      end


      def render_head_meta_tags
        write_tag_meta_charset_utf8
        if @head_includes_metadata_tags
          @head_metadata.each_pair do |key, value|
            write_tag_meta(key, value)
          end
        end
        write_tag_meta_generator
        write_tag_meta_viewport
      end


      def render_tag_html_open
        write_tag_doctype
        if @html_lang
          write_tag_html_open_lang
        else
          write_tag_html_open
        end
      end


      def write_css_if_manifest_exists
        if @project.exceptions_include?(ProjectException::CssManifestFileNotFound)
          write_css_missing_comment
        else
          write_css
        end
      end


      def write_css
        @destination.write_inline SassC::Engine.new(File.read(@project.css_manifest_filename), syntax: :scss, load_paths: ['config/css']).render
      end


      def write_css_missing_comment
        @destination.write_line "/*"
        @destination.write_line "#{ProjectException::CssManifestFileNotFound}"
        @destination.write_line "  - CSS manifest file could not be found."
        @destination.write_line "  - Expecting `#{project.css_manifest_filename}`"
        @destination.write_line "*/"
      end


      def write_js_library(library)
        @destination.write_inline RenderHtmlPartial::JsLibrary.new.find(library)
      end


      def write_tag_body_close
        @destination.write_line tag_body_close
      end


      def write_tag_body_open
        @destination.write_line tag_body_open
      end


      def write_tag_doctype
        @destination.write_line tag_doctype
      end


      def write_tag_head_close
        @destination.write_line tag_head_close
      end


      def write_tag_head_open
        @destination.write_line tag_head_open
      end


      def write_tag_html_close
        @destination.write_line tag_html_close
      end


      def write_tag_html_open
        @destination.write_line tag_html_open
      end


      def write_tag_html_open_lang
        @destination.write_line tag_html_open_lang
      end


      def write_tag_link_stylesheet
        @destination.write_line tag_link_stylesheet
      end


      def write_tag_meta(key, value)
        @destination.write_line tag_meta(key, value)
      end


      def write_tag_meta_charset_utf8
        @destination.write_line tag_meta_charset_utf8
      end


      def write_tag_meta_generator
        @destination.write_line tag_meta_generator
      end


      def write_tag_meta_viewport
        @destination.write_line tag_meta_viewport
      end


      def write_tag_meta_instance_date
        @destination.write_line tag_meta_instance_date
      end


      def write_tag_script_close
        @destination.write_line tag_script_close
      end


      def write_tag_script_open
        @destination.write_line tag_script_open
      end


      def write_tag_script_src
        @destination.write_line tag_script_src
      end


      def write_tag_style_close
        @destination.write_line tag_style_close
      end


      def write_tag_style_open
        @destination.write_line tag_style_open
      end


      def write_tag_title
        @destination.write_line tag_title
      end



      private


      def tag_body_close
        "</main></body>"
      end


      def tag_body_open
        "<body><main>"
      end


      def tag_doctype
        "<!DOCTYPE html>"
      end


      def tag_head_close
        "</head>"
      end


      def tag_head_open
        "<head>"
      end


      def tag_html_close
        "</html>"
      end


      def tag_html_open
        "<html>"
      end


      def tag_html_open_lang
        "<html lang='#{@html_lang}'>"
      end


      def tag_link_stylesheet
        "<link rel='stylesheet' href='#{@head_css_filename}' type='text/css'>"
      end


      def tag_meta(key, value)
        "<meta name='#{key}' value='#{value}'>"
      end


      def tag_meta_charset_utf8
        "<meta charset='UTF-8'>"
      end


      def tag_meta_generator
        "<meta name='generator' content='Muwu #{Muwu::VERSION}'>"
      end


      def tag_meta_instance_date
        "<meta name='date_of_this_edition' value='#{@project.instance_date}'>\n"
      end


      def tag_meta_viewport
        "<meta name='viewport' content='width=device-width, initial-scale=1, user-scalable=yes'>"
      end


      def tag_script_close
        "</script>"
      end


      def tag_script_open
        "<script>"
      end


      def tag_script_src
        "<script src='#{@head_js_filename}'></script>"
      end


      def tag_style_close
        "</style>"
      end


      def tag_style_open
        "<style>"
      end


      def tag_title
        "<title>#{@html_title}</title>"
      end


    end
  end
end
