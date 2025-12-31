module Muwu
  module Helper
    module HrefHelper


      module_function


      def id_contents_item(topic)
        hyphenate(['contents', topic.text_root_name, topic.id])
      end


      def id_subcontents_item(topic)
        hyphenate(['subcontents', topic.text_root_name, topic.id])
      end


      def id_topic_header(topic)
        hyphenate(['text', topic.text_root_name, topic.id])
      end


      def link_to_contents_item(topic, from: nil)
        target_filename_contents(topic, from: from) + '#' + id_contents_item(topic)
      end


      def link_to_project_home(project)
        project.manifest.find_document_html_by_index(0).destination.output_filename
      end


      def link_to_document_top
        '#top'
      end


      def link_to_subcontents_item(topic, from: nil)
        target_filename_subcontents(topic, from: from) + '#' + id_subcontents_item(topic)
      end


      def link_to_topic_header(topic, from: nil)
        target_filename_topic(topic, from: from) + '#' + id_topic_header(topic)
      end


      private


      def self.hyphenate(a)
        a.join('-')
      end


      def self.target_filename_contents(topic, from: nil)
        contents_destination_output_filename = topic.project.manifest.contents_block_filename_for(topic.text_root_name)
        case from
        when :topic
          if contents_destination_output_filename == topic.destination.output_filename
            return ''
          else
            return contents_destination_output_filename
          end
        else
          return contents_destination_output_filename
        end
      end


      def self.target_filename_subcontents(topic, from: nil)
        case from
        when :topic
          return ''
        else
          return topic.destination.output_filename
        end
      end


      def self.target_filename_topic(topic, from: nil)
        case from
        when :contents
          contents_destination_output_filename = topic.project.manifest.contents_block_filename_for(topic.text_root_name)
          if contents_destination_output_filename == topic.destination.output_filename
            return ''
          else
            return topic.destination.output_filename
          end
        when :subcontents
          return ''
        else
          return topic.destination.output_filename
        end
      end


    end
  end
end
