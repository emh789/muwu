module Muwu
  module Helper
    class HtmlHrefHelper
  
  
      include Muwu
      
  
      attr_accessor(
        :origin_task,
      )
  
  
      def initialize(origin_task)
        @origin_task = origin_task
        @project = origin_task.project
      end
      

            
      public
      
      
      def to_topic(text_object)
        result = ''
        case @origin_task
        when ManifestTask::Contents
          result = target_text_filename(text_object) + attr_id(:text, text_object)
        when ManifestTask::Subcontents
          result = attr_id(:text, text_object)
        end
        result
      end
      

      def to_contents_heading(text_object)
        result = ''
        case @origin_task
        when ManifestTask::Topic
          filename = target_contents_filename(text_object)
          anchor_id = attr_id(:contents, text_object)
          result = filename + anchor_id
        end
        result
      end


      def to_document_top
        '#top'
      end


      def to_project_home
        @project.manifest.find_document_html_by_index(0).destination.output_filename
      end
      


      private
      
      
      def attr_id(target, text_object)
        prefix = '#'
        block_type = target.to_s
        root_name = target_text_root_name(text_object)
        section_number = target_section_number_as_attr(text_object)
        prefix + ([block_type, root_name, section_number].compact.join('_'))
      end
      
            
      def target_contents_filename(text_object)
        result = ''
        if @project.has_multiple_html_documents
          result = File.basename(@project.manifest.contents_block_by_name(text_object.text_root_name).destination.output_filename)
        end
        result
      end
      
      
      def target_text_filename(text_object)
        result = ''
        if @project.has_multiple_html_documents
          result = File.basename(text_object.destination.output_filename)
        end
        result
      end
      
      
      def target_text_root_name(text_object)
        text_object.text_root_name
      end
            
      
      def target_section_number_as_attr(text_object)
        text_object.numbering_to_depth_max.join('_')
      end
      
      
    end
  end
end
