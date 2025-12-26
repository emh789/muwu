module Muwu
  class RenderConcat


    def initialize(project)
      @output_path = project.path_compiled
      @output_filename = project.html_basename + '.md'
      @project = project
      @manifest = project.manifest
    end


    public


    def render
      destination = File.join(@output_path, @output_filename)
      puts "- Writing `#{@output_filename}`"
      File.open(destination, 'w') do |f|
        @manifest.text_blocks.each do |text|
          text.sections.each do |topic|
            render_topic(f, topic)
          end
        end
      end
    end


    def render_topic(f, topic)
      render_topic_head(f, topic)
      render_topic_source(f, topic)
      render_topic_sections(f, topic)
    end


    def render_topic_head(f, topic)
      f.puts '# ' + topic.numbering.join('.')
      if heading_origin_is_basename_or_outline(topic)
        f.puts '# ' + topic.heading
        f.puts "\n"
      end
    end


    def render_topic_sections(f, topic)
      if topic.does_have_child_sections
        topic.sections.each do |ti|
          render_topic(f, ti)
        end
        render_topic_spacer(f, topic)
      end
    end


    def render_topic_source(f, topic)
      if topic.source_file_does_exist
        f.puts topic.source.strip
      end
      render_topic_spacer(f, topic)
    end


    def render_topic_spacer(f, topic)
      f.puts "\n\n\n\n"
    end



    private


    def heading_origin_is_basename_or_outline(topic)
      [:basename, :outline].include?(topic.heading_origin)
    end



  end
end
