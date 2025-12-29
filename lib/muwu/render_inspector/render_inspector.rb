module Muwu
  class RenderInspector


    include Muwu


    COLUMN_LEFT = 12
    SEPARATOR = '  '


    def initialize(project)
      @project = project
    end



    public


    def render_inspector
      render_inspector_project
      render_inspector_options
      render_inspector_manifest
      render_inspector_errors
    end


    def render_inspector_errors
      if @project.exceptions.any?
        @project.exceptions.each do |error|
          render_inspector_error_report(error)
        end
        puts
      end
    end


    def render_inspector_manifest
      @project.manifest.documents.each do |document|
        case document
        when ManifestTask::DocumentCss
          render_inspector_document_css(document)
        when ManifestTask::DocumentHtml
          render_inspector_document_html(document)
        when ManifestTask::DocumentJs
          render_inspector_document_js(document)
        end
      end
    end


    def render_inspector_options
      puts @project.options
      @project.options.instance_variables.each do |option|
        key = option.to_s.gsub(/\A@/,'')
        value = @project.options.instance_variable_get(option)
        puts indent("#{key}: #{value}")
      end
      puts
    end


    def render_inspector_project
      puts @project
      puts indent("slug: #{@project.slug}")
      puts indent("working_directory: #{@project.working_directory}")
      puts indent("js_libraries: #{@project.javascript_libraries_requested}")
      puts
    end



    private


    def column_left(text)
      text.ljust(COLUMN_LEFT)
    end


    def indent(text)
      column_left(text).prepend('  ')
    end


    def puts_line(output=nil)
      if Array === output
        puts output.compact.join(SEPARATOR)
      elsif NilClass === output
        puts "\n"
      else
        puts output
      end
    end


    def render_inspector_document_css(document)
      puts_line [document.to_s]
      puts_line [document.destination.to_s, document.destination.output_class, document.destination.output_filename]
      puts_line
    end


    def render_inspector_document_html(document)
      puts_line [document.to_s, "index: #{document.index}"]
      puts_line [document.destination.to_s, document.destination.output_class, document.destination.output_filename]
      document.tasks.each do |task|
        render_inspector_manifest_task(task)
      end
      puts_line
    end


    def render_inspector_document_js(document)
      puts_line [document.to_s]
      puts_line [
        document.destination.to_s,
        document.destination.output_class,
        document.destination.output_filename
      ]
      puts_line
    end


    def render_inspector_error_report(error)
      puts_line [
        column_left(error.type.to_s),
        error.report
      ]
    end


    def render_inspector_manifest_task(task)
      case task
      when ManifestTask::Contents
        render_inspector_manifest_task_contents(task)
      when ManifestTask::Metadata
        render_inspector_manifest_task_metadata(task)
      when ManifestTask::Navigator
        render_inspector_manifest_task_navigator(task)
      when ManifestTask::Subcontents
        render_inspector_manifest_task_subcontents(task)
      when ManifestTask::Title
        render_inspector_manifest_task_title(task)
      when ManifestTask::Text
        render_inspector_manifest_task_text(task)
      when ManifestTask::Topic
        render_inspector_manifest_task_topic(task)
      end
    end


    def render_inspector_manifest_task_contents(contents)
      puts_line [
        indent('Contents'),
        contents.naming.inspect
      ]
    end


    def render_inspector_manifest_task_metadata(metadata)
      puts_line [
        indent('Metadata'),
        metadata.metadata.to_s
      ]
    end


    def render_inspector_manifest_task_navigator(navigator)
      puts_line [
        indent('Navigator'),
        "prev: #{navigator.document_prev_index}",
        "home: #{navigator.document_home_index}",
        "next: #{navigator.document_next_index}"
      ]
    end


    def render_inspector_manifest_task_subcontents(contents)
      puts_line [
        indent('Subcontents'),
        contents.naming.inspect
      ]
    end


    def render_inspector_manifest_task_text(text)
      puts_line [
        indent('Text'),
        text.naming.inspect
      ]
      text.topics.each do |topic|
        render_inspector_manifest_task(topic)
      end
    end


    def render_inspector_manifest_task_topic(topic)
      puts_line [
        indent("| Topic #{topic.id}"),
        topic.numbering.inspect,
        topic.heading.inspect,
        topic.source_filename,
        ('!!' if topic.source_file_does_not_exist)
      ]
      if topic.does_have_subtopics
        topic.subtopics.each do |subtopic|
          render_inspector_manifest_task(subtopic)
        end
      end
    end


    def render_inspector_manifest_task_title(title)
      puts_line [
        indent('Title'),
        title.metadata.to_s
      ]
    end


  end
end
