module Muwu
  module RenderHtmlPartial
    class Navigator


      attr_accessor(
        :destination,
        :heading,
        :href_document_home,
        :href_document_next,
        :href_document_prev
      )


      def render
        @destination.margin_to_zero
        @destination.padding_vertical(1) do
          # write_tag_div_open
          # render_heading
          write_tag_nav_open
          render_prev
          render_home
          render_next
          write_tag_nav_close
          # write_tag_div_close
        end
      end


      def render_heading
        write_tag_heading
      end


      def render_prev
        write_tag_a_prev
      end


      def render_home
        write_tag_a_home
      end


      def render_next
        write_tag_a_next
      end


      def write_tag_a_home
        @destination.write_line tag_a_home
      end


      def write_tag_a_next
        @destination.write_line tag_a_next
      end


      def write_tag_a_prev
        @destination.write_line tag_a_prev
      end


      def write_tag_div_close
        @destination.write_line tag_div_close
      end


      def write_tag_div_open
        @destination.write_line tag_div_open
      end


      def write_tag_heading
        @destination.write_line tag_heading
      end


      def write_tag_nav_open
        @destination.write_line tag_nav_open
      end


      def write_tag_nav_close
        @destination.write_line tag_nav_close
      end



      private


      def tag_a_home
        "<a class='document_link' href='#{@href_document_home}'>[home]</a>"
      end


      def tag_a_next
        "<a class='document_link' href='#{@href_document_next}'>[next]</a>"
      end


      def tag_a_prev
        "<a class='document_link' href='#{@href_document_prev}'>[prev]</a>"
      end


      def tag_div_close
        "</div>"
      end


      def tag_div_open
        "<div class='navigator'>"
      end


      def tag_heading
        "<h1>#{@heading}</h1>"
      end


      def tag_nav_close
        "</nav>"
      end


      def tag_nav_open
        "<nav data-document-block='navigator' class='document_links'>"
      end


    end
  end
end
