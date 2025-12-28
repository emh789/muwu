module Muwu
  module RenderHtmlPartial
    class Text


      include Muwu


      attr_accessor(
        :destination,
        :html_attr_id,
        :project,
        :text_root_name,
        :sections,
        :will_render_end_links,
        :will_render_section_numbers
      )


      def render
        @destination.padding_vertical(1) do
          render_tag_div_open
          render_sections
          render_tag_div_close
        end
      end


      def render_sections
        @destination.padding_vertical(1) do
          @sections.each do |section|
            section.render
          end
        end
      end


      def render_tag_div_close
        write_tag_div_close
      end


      def render_tag_div_open
        write_tag_div_open
      end


      def write_tag_div_close
        @destination.write_line tag_div_close
      end


      def write_tag_div_open
        @destination.write_line tag_div_open
      end



      private


      def tag_div_close
        "</div>"
      end


      def tag_div_open
        "<div data-document-block='text' data-text_root_name='#{@text_root_name}' id='#{@html_attr_id}'>"
      end


    end
  end
end
