module Muwu
  module ManifestTaskBuilders
    class TextBuilder


      include Muwu
      include Helper


      attr_accessor(
        :outline_text,
        :parent_document,
        :project,
        :text
      )


      def self.build
        builder = new
        yield(builder)
        builder.text
      end


      def initialize
        @text = ManifestTask::Text.new
      end


      def build_from_outline(outline_text, parent_document)
        @outline_text = outline_text
        @parent_document = parent_document
        @project = parent_document.project
        set_project
        set_destination
        set_naming
        set_numbering
        set_sections
      end

    
      def set_destination
        @text.destination = @parent_document.destination
      end

  
      def set_naming
        @text.naming = [determine_text_block_name]
      end


      def set_numbering
        @text.numbering = []
      end
        

      def set_project
        @text.project = @project
      end
  
  
      def set_sections
        @text.sections = build_sections
      end



      private


      def build_sections
        sections = []
        child_steps = determine_text_block_steps
        if child_steps.empty? == false
          child_section_numbering = section_number_extend(@text.numbering)
          child_steps.each do |step|
            child_section_numbering = section_number_find(child_section_numbering, step)
            sections << build_topic(step, child_section_numbering)
          end
        end
        sections
      end
  
  
      def build_topic(step, section_numbering)
        ManifestTaskBuilders::TopicBuilder.build do |b|
          b.build_from_outline_fragment_text(step, section_numbering, @text)
        end
      end


      def determine_text_block_name
        directive = @outline_text.flatten[0]
        components = directive.partition(RegexpLib.outline_text_plus_whitespace)
        text_block_name = components[2].to_s.downcase.strip
        if text_block_name == ''
          text_block_name = @project.default_text_block_name
        end
        text_block_name
      end
  
  
      def determine_text_block_steps
        @outline_text.flatten[1]
      end


      def section_number_extend(number_incoming)
        number_outgoing = number_incoming.clone
        number_outgoing << 0
        number_outgoing
      end

      
      def section_number_find(number_incoming, step)
        number_outgoing = number_incoming.clone
        sorted_outline_steps = @project.outline_text_blocks_named(@text.text_root_name)
        number_outgoing[-1] = sorted_outline_steps.index(step) + 1
        number_outgoing
      end
      
  
    end
  end
end
