module Muwu
  module RenderHtmlPartial
    class Metadata


      include Muwu


      attr_accessor(
        :destination,
        :metadata
      )


      def render
        @destination.margin_to_zero
        @destination.padding_vertical(1) do
          write_tag_div_open
          render_dl
          write_tag_div_close
        end
        @destination.margin_to_zero
      end


      def render_dl
        @destination.margin_indent do
          write_tag_dl_open
          render_dl_metadata_div
          write_tag_dl_close
        end
      end


      def render_dl_metadata_div
        @destination.margin_indent do
          @metadata.each_pair do |key, value|
            write_tag_div_metadata(key, value)
          end
        end
      end


      def write_tag_div_close
        @destination.write_line tag_div_close
      end


      def write_tag_div_open
        @destination.write_line tag_div_open
      end


      def write_tag_dl_close
        @destination.write_line tag_dl_close
      end


      def write_tag_dl_open
        @destination.write_line tag_dl_open
      end


      def write_tag_div_metadata(key, value)
        @destination.margin_indent do
          @destination.write_line tag_dt_key(key)
          @destination.write_line tag_dd_value(value)
        end
      end



      private


      def tag_dd_value(value)
        "<dd>#{value}</dd>"
      end


      def tag_div_close
        "</div>"
      end


      def tag_div_open
        "<div data-document-block='metadata'>"
      end


      def tag_dl_close
        "</dl>"
      end


      def tag_dl_open
        "<dl>"
      end


      def tag_dt_key(key)
        "<dt>#{key}</dt>"
      end


    end
  end
end
