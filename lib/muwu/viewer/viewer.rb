module Muwu
  class Viewer


    include Muwu


    def initialize(project)
      document_home = project.manifest.find_document_html_by_index(0)
      if document_home
        @document_home_filepath = File.join(project.path_compiled, document_home.filename)
      else
        raise ProjectExceptionHandler::Fatal.new(ProjectException::ViewerMissingHomeDocument.new)
      end
    end


    public


    def view
      if @document_home_filepath && File.exist?(@document_home_filepath)
        view_home_document
      else
        raise ProjectExceptionHandler::Fatal.new(ProjectException::ViewerMissingHomeDocument.new)
      end
    end


    def view_home_document
      begin
        system "open #{@document_home_filepath}", exception: true
      rescue Errno::ENOENT
        raise ProjectExceptionHandler::Fatal.new(ProjectException::NoHTMLViewerConfigured.new)
      end
    end


  end
end
