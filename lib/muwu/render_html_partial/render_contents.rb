module Muwu
  module RenderHtmlPartial
    class Contents


      require 'cgi'


      include Muwu


      attr_accessor(
        :destination,
        :html_attr_id,
        :item_depth_max,
        :project,
        :topics,
        :text_root_name,
        :will_render_section_numbers
      )



      public


      def render
        @destination.margin_to_zero
        @destination.padding_vertical(1) do
          write_tag_div_open
          render_contents_heading
          render_contents_element(@topics)
          write_tag_div_close
        end
        @destination.margin_to_zero
      end


      def render_contents_element(topics)
        @destination.margin_indent do
          case @will_render_section_numbers
          when false
            render_ol(topics)
          when true
            render_table(topics)
          end
        end
      end


      def render_contents_heading
        write_tag_h1_contents_heading
      end


      def render_ol(topics)
        write_tag_ol_open
        @destination.margin_indent do
          topics.each do |topic|
            render_ol_li(topic)
          end
        end
        write_tag_ol_close
      end


      def render_ol_li(topic)
        if task_depth_is_within_range(topic)
          html_id = Helper::HrefHelper.id_contents_item(topic)
          if topic.is_parent_heading
            write_tag_li_open(html_id)
            @destination.margin_indent do
              render_ol_li_heading_and_subsections(topic)
            end
            write_tag_li_close_outline
          elsif topic.is_not_parent_heading
            write_tag_li_open(html_id)
            render_ol_li_heading(topic)
            write_tag_li_close_inline
          end
        end
      end


      def render_ol_li_heading(topic)
        render_tag_a_section_heading(topic)
      end


      def render_ol_li_heading_and_subsections(topic)
        render_tag_a_section_heading(topic, trailing_line_feed: true)
        render_ol(topic.subtopics)
      end


      def render_table(topics)
        write_tag_table_open
        @destination.margin_indent do
          topics.each do |topic|
            render_table_tr(topic)
          end
        end
        write_tag_table_close
      end


      def render_table_tr(topic)
        if task_depth_is_within_range(topic)
          html_id = Helper::HrefHelper.id_contents_item(topic)
          write_tag_tr_open(html_id)
          @destination.margin_indent do
            if topic.is_parent_heading
              render_table_tr_td_number(topic)
              render_table_tr_td_heading_and_subsections(topic)
            elsif topic.is_not_parent_heading
              render_table_tr_td_number(topic)
              render_table_tr_td_heading(topic)
            end
          end
          write_tag_tr_close
        end
      end


      def render_table_tr_td_heading(topic)
        write_tag_td_open(attr_list: "data-contents='table-topic'")
        render_tag_a_section_heading(topic)
        write_tag_td_close_inline
      end


      def render_table_tr_td_heading_and_subsections(topic)
        write_tag_td_open(attr_list: "data-contents='table-topic'")
        render_tag_a_section_heading(topic, trailing_line_feed: true)
        @destination.margin_indent do
          render_table(topic.subtopics)
        end
        write_tag_td_close_outline
      end


      def render_table_tr_td_number(topic)
        write_tag_td_open(attr_list: "data-contents='table-number'")
        render_tag_a_section_number(topic, attr_list: "tabindex='-1'")
        write_tag_td_close_inline
      end


      def render_tag_a_section_heading(topic, trailing_line_feed: false)
        href = Helper::HrefHelper.link_to_topic_header(topic, from: :contents)
        write_tag_a_open(href)
        write_text_section_heading(topic)
        write_tag_a_close
        if trailing_line_feed
          write_lf
        end
      end


      def render_tag_a_section_number(topic, attr_list: nil)
        href = Helper::HrefHelper.link_to_topic_header(topic, from: :contents)
        write_tag_a_open(href, attr_list: attr_list)
        write_text_section_number(topic)
        write_tag_a_close
      end


      def write_lf
        @destination.write_lf
      end


      def write_tag_a_close
        @destination.write_inline tag_a_close
      end


      def write_tag_a_open(href_id, attr_list: nil)
        @destination.write_inline tag_a_open(href_id, attr_list: attr_list)
      end


      def write_tag_div_close
        @destination.write_line tag_div_close
      end


      def write_tag_div_open
        @destination.write_line tag_div_open
      end


      def write_tag_h1_contents_heading
        @destination.write_line tag_h1_contents_heading
      end


      def write_tag_li_close
        write_tag_li_close_outline
      end


      def write_tag_li_close_inline
        @destination.write_inline_end tag_li_close
      end


      def write_tag_li_close_outline
        @destination.write_line tag_li_close
      end


      def write_tag_li_open(html_id)
        @destination.write_inline_indented tag_li_open(html_id)
      end


      def write_tag_ol_close
        @destination.write_line tag_ol_close
      end


      def write_tag_ol_open
        @destination.write_line tag_ol_open
      end


      def write_tag_table_close
        @destination.write_line tag_table_close
      end


      def write_tag_table_open
        @destination.write_line tag_table_open
      end


      def write_tag_td_close
        write_tag_td_close_outline
      end


      def write_tag_td_close_inline
        @destination.write_inline_end tag_td_close
      end


      def write_tag_td_close_outline
        @destination.write_line tag_td_close
      end


      def write_tag_td_open(attr_list: nil)
        @destination.write_inline_indented tag_td_open(attr_list: attr_list)
      end


      def write_tag_tr_close
        @destination.write_line tag_tr_close
      end


      def write_tag_tr_open(html_id)
        @destination.write_line tag_tr_open(html_id)
      end


      def write_text_section_heading(textobject)
        @destination.write_inline CGI::escape_html(textobject.heading)
      end


      def write_text_section_number(textobject)
        @destination.write_inline textobject.numbering.join('.')
      end



      private


      def tag_a_close
        "</a>"
      end


      def tag_a_open(href, attr_list: nil)
        ["<a", "class='document_link'", "href='#{href}'", attr_list].compact.join(' ').concat('>')
      end


      def tag_div_close
        "</div>"
      end


      def tag_div_open
        "<div data-document-block='contents' data-text-root-name='#{@text_root_name}' id='#{@html_attr_id}'>"
      end


      def tag_h1_contents_heading
        "<h1 data-contents='heading'>Contents</h1>"
      end


      def tag_li_close
        "</li>"
      end


      def tag_li_open(html_id)
        "<li data-contents='list-topic' id='#{html_id}'>"
      end


      def tag_ol_close
        "</ol>"
      end


      def tag_ol_open
        "<ol data-contents='list'>"
      end


      def tag_table_close
        "</table>"
      end


      def tag_table_open
        "<table data-contents='table'>"
      end


      def tag_td_close
        "</td>"
      end


      def tag_td_open(attr_list: nil)
        ["<td", attr_list].compact.join(' ').concat('>')
      end


      def tag_tr_close
        "</tr>"
      end


      def tag_tr_open(html_id)
        "<tr id='#{html_id}'>"
      end


      def task_depth_is_within_range(topic)
        result = nil
        if @item_depth_max == nil
          result = true
        elsif topic.topic_depth <= @item_depth_max
          result = true
        elsif topic.topic_depth > @item_depth_max
          result = false
        end
        result
      end


    end
  end
end
