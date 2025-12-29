module Muwu
  module RenderHtmlPartialBuilder
    class TextBuilder


      include Muwu


      attr_accessor(
        :manifest_text,
        :project,
        :renderer
      )


      def self.build
        builder = new
        yield(builder)
        builder.renderer
      end


      def initialize
        @renderer = RenderHtmlPartial::Text.new
      end


      def build_from_manifest_text(text)
        @manifest_text = text
        @project = text.project
        set_destination
        set_project
        set_text_root_name
        set_topics
        finally_set_html_attr_id
      end


      def finally_set_html_attr_id
        @renderer.html_attr_id = ['text', @renderer.text_root_name].join('_')
      end


      def set_destination
        @renderer.destination = @manifest_text.destination
      end


      def set_project
        @renderer.project = @project
      end


      def set_text_root_name
        @renderer.text_root_name = @manifest_text.text_root_name
      end


      def set_topics
        @renderer.topics = determine_topics
      end



      private


      def determine_topics
        topics = []
        @manifest_text.topics.each do |topic|
          topics << build_topic(topic)
        end
        topics
      end


      def build_topic(topic)
        RenderHtmlPartialBuilder::TopicBuilder.build do |b|
          b.build_from_manifest_topic(topic)
        end
      end


    end
  end
end
