module Muwu
  class ControllerInteraction


    attr_accessor :slug


    def initialize
      @slug = ''
    end



    public


    def confirm_reset_compiled(project)
      render_reset_compiled_heading
      render_reset_compiled_prompt
      @answer = $stdin.gets.chomp.strip.downcase
      if @answer == 'y'
        return true
      else
        return false
      end
    end


    def confirm_reset_css(project)
      render_reset_css_heading(project)
      render_reset_css_prompt
      @answer = $stdin.gets.chomp.strip.downcase
      if @answer == 'y'
        return true
      else
        return false
      end
    end


    def request_metadata
      request_metadata_phase_1_render_heading
      request_metadata_phase_2_request_and_set_slug
      { slug: @slug }
    end


    def request_metadata_phase_1_render_heading
      render_new_project_heading
      render_lf
    end


    def request_metadata_phase_2_request_and_set_slug
      render_slug_heading
      while @slug == ''
        render_slug_can_not_be_blank
        render_slug_prompt
        @slug = $stdin.gets.chomp.strip
        if @slug.match(/\W/)
          @slug.gsub!(/\W/,'')
          render_slug_was_sanitized(result: @slug)
        end
      end
      render_lf
    end



    private



    def determine_reset_css_files(project)
      [
        File.join(project.path_css_base),
        File.join(project.path_css_colors, 'dark.scss'),
        File.join(project.path_css_colors, 'index.scss'),
        File.join(project.path_css_colors, 'light.scss'),
        File.join(project.path_css, 'index.scss'),
      ]
    end


    def render_lf
      puts "\n"
    end


    def render_new_project_heading
      puts '# Muwu'
      puts '# New Project'
    end


    def render_reset_compiled_heading
      puts '# Muwu'
      puts '# Reset `compiled/`'
      puts
      puts '- This will remove all contents of the `compiled/` folder.'
      puts '- This action cannot be undone.'
      puts
    end


    def render_reset_compiled_prompt
      print '> Continue resetting the `compiled/` folder? (y/N) '
    end


    def render_reset_css_heading(project)
      puts '# Muwu'
      puts '# Reset CSS'
      puts ''
      puts 'This will reset the following files and folders to their original state:'
      determine_reset_css_files(project).each do |file|
        puts "  - #{file}"
      end
      puts
      puts "If #{project.path_css_extensions} does not exist, it will be created."
      puts 'Otherwise, its existing contents will remain unchanged.'
      puts
      puts '- This action cannot be undone'
      puts
    end


    def render_reset_css_prompt
      print '> Continue with CSS reset? (y/N) '
    end


    def render_slug_heading
      puts '# Project Directory Name'
      puts '- Word characters `[a-zA-Z0-9_]` only; non-word characters will be removed.'
    end


    def render_slug_prompt
      print '> Directory Name for project: '
    end


    def render_slug_can_not_be_blank
      puts '- Directory Name can not be blank.'
    end


    def render_slug_was_sanitized(result: nil)
      puts '- Directory Name contained non-word characters that were removed.'
      if result
        puts "  - Modified Directory Name: `#{result}`"
      end
    end


    def render_title_heading
      puts "\n"
      puts '# Project Title'
    end


    def render_title_prompt
      print '> Title of project: '
    end


    def render_title_can_not_be_blank
      puts '- Title can not be blank.'
    end


  end
end
