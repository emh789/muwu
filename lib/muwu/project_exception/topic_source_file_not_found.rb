module Muwu
  module ProjectException
    class TopicSourceFileNotFound


      def initialize(text_readfile)
        @filename = text_readfile.source_filename
        @numbering = text_readfile.numbering
        @text_root_name = text_readfile.text_root_name
      end


      def report
        "file not found  `#{@filename}`  (#{@text_root_name} #{@numbering})"
      end


      def type
        :warning
      end


    end
  end
end
