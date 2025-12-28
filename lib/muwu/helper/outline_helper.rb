module Muwu
  module Helper
    class OutlineHelper


      include Muwu::Helper


      def initialize(outline_fragment)
        @outline_fragment = outline_fragment
      end



      public


      def includes_navigator
        indicates_navigator || includes_navigator_in_array
      end


      def includes_navigator_in_array
        (is_array) && (@outline_fragment.select{ |step| OutlineHelper.type_of(step) == :navigator }.any?)
      end


      def indicates_contents
        indicates_contents_hash || indicates_contents_string
      end


      def indicates_contents_hash
        (is_hash) && (RegexpLib.outline_contents =~ @outline_fragment.flatten[0])
      end


      def indicates_contents_string
        (is_string) && (RegexpLib.outline_contents =~ @outline_fragment)
      end


      def indicates_metadata
        indicates_metadata_hash || indicates_metadata_string
      end


      def indicates_metadata_hash
        (is_hash) && (RegexpLib.outline_metadata =~ @outline_fragment.flatten[0])
      end


      def indicates_metadata_string
        (is_string) && (RegexpLib.outline_metadata =~ @outline_fragment)
      end


      def indicates_navigator
        (is_string) && (RegexpLib.outline_navigator =~ @outline_fragment)
      end


      def indicates_outline_fragment
        is_array
      end


      def indicates_subcontents
        indicates_subcontents_hash || indicates_subcontents_string
      end


      def indicates_subcontents_hash
        (is_hash) && (RegexpLib.outline_subcontents =~ @outline_fragment.flatten[0])
      end


      def indicates_subcontents_string
        (is_string) && (RegexpLib.outline_subcontents =~ @outline_fragment)
      end


      def indicates_text
        (is_hash) && (RegexpLib.outline_text =~ @outline_fragment.flatten[0])
      end


      def indicates_title
        indicates_title_hash || indicates_title_string
      end


      def indicates_title_hash
        (is_hash) && (RegexpLib.outline_title =~ @outline_fragment.flatten[0])
      end


      def indicates_title_string
        (is_string) && (RegexpLib.outline_title =~ @outline_fragment)
      end


      def is_array
        Array === @outline_fragment
      end


      def is_hash
        Hash === @outline_fragment
      end


      def is_integer
        Integer === @outline_fragment
      end


      def is_string
        String === @outline_fragment
      end


      def text_step_flexible_suggests_file
        if @outline_fragment.to_s =~ RegexpLib.file_ext_md
          true
        else
          false
        end
      end



      protected


      def self.type_of(step)
        s = new(step)
        if s.indicates_contents
          :contents
        elsif s.indicates_metadata
          :metadata
        elsif s.indicates_navigator
          :navigator
        elsif s.indicates_outline_fragment
          :outline_fragment
        elsif s.indicates_subcontents
          :subcontents
        elsif s.indicates_text
          :text
        elsif s.indicates_title
          :title
        end
      end


    end
  end
end
