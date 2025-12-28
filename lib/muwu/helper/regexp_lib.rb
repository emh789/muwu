module Muwu
  module Helper
    module RegexpLib


      module_function


      def file_ext_md
        /.md\z/i
      end


      def markdown_heading
        /\A#+/
      end


      def markdown_heading_plus_whitespace
        /\A#+\s*/
      end


      def metadata_key_date_of_this_edition
        /\Adate\s*of\s*this\s*edition/i
      end


      def not_alphanumeric_underscore_or_single_dot
        /[^a-zA-Z0-9_\.]/
      end


      def outline_metadata
        /\Ametadata/i
      end


      def outline_navigator
        /\Anavigator/i
      end


      def outline_contents
        /\Acontents/i
      end


      def outline_subcontents
        /\Asubcontents/i
      end


      def outline_text
        /\Atext/i
      end


      def outline_text_plus_whitespace
        /\Atext\s+/i
      end


      def outline_title
        /\Atitle/i
      end


      def path_two_or_more_dots
        /\.{2,}/
      end


    end
  end
end
