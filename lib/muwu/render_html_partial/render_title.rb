module Muwu
  module RenderHtmlPartial
    class Title


      include Muwu


      attr_accessor(
        :destination,
        :metadata
      )


      def render
        @destination.margin_to_zero
        @destination.padding_vertical(1) do
          write_tag_div_open
          render_title_metadata
          write_tag_div_close
        end
        @destination.margin_to_zero
      end


      def render_title_metadata
        @destination.margin_indent do
          @metadata.each_pair do |key, value|
            write_tag_h1(key, value)
          end
        end
      end


      def write_tag_div_close
        @destination.write_line tag_div_close
      end


      def write_tag_div_open
        @destination.write_line tag_div_open
      end


      def write_tag_h1(key, value)
        @destination.write_line tag_h1(key, value)
      end



      private


      def tag_h1(key, value)
        "<h1 data-title-attr='#{key.downcase}'>#{value}</h1>"
      end


      def tag_div_close
        "</div>"
      end


      def tag_div_open
        "<div data-document-block='title'>"
      end


    end
  end
end
