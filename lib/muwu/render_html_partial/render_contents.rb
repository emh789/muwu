module Muwu
  module RenderHtmlPartial
    class Contents


      require 'cgi'


      include Muwu
        
        
      attr_accessor(
        :destination,
        :href_helper,
        :html_attr_id,
        :item_depth_max,
        :project,
        :sections,
        :text_root_name,
        :will_render_section_numbers
      )
      
      
      
      public
  

      def render
        @destination.margin_to_zero
        @destination.padding_vertical(1) do
          write_tag_div_open
          render_contents_heading
          render_contents_element(@sections)
          write_tag_div_close
        end
        @destination.margin_to_zero
      end

  
      def render_contents_element(sections)
        @destination.margin_indent do
          case @will_render_section_numbers
          when false
            render_ol(sections)
          when true
            render_table(sections)
          end
        end
      end
      
      
      def render_contents_heading
        write_tag_h1_contents_heading
      end
    
    
      def render_ol(topic)
        write_tag_ol_open
        @destination.margin_indent do 
          topic.each do |section|
            render_ol_li(section)
          end
        end
        write_tag_ol_close
      end
  
  
      def render_ol_li(topic)
        if task_depth_is_within_range(topic)
          if topic.is_parent_heading
            write_tag_li_open
            @destination.margin_indent do 
              render_ol_li_heading_and_subsections(topic)
            end
            write_tag_li_close_outline
          elsif topic.is_not_parent_heading
            write_tag_li_open
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
        render_ol(topic.sections)
      end


      def render_table(topic)
        write_tag_table_open
        @destination.margin_indent do 
          topic.each do |section|
            render_table_tr(section)
          end
        end
        write_tag_table_close
      end


      def render_table_tr(section)
        if task_depth_is_within_range(section)
          html_id = ['contents', @text_root_name, section.numbering.join('_')].join('_')
          write_tag_tr_open(html_id)
          @destination.margin_indent do 
            if section.is_parent_heading
              render_table_tr_td_number(section)
              render_table_tr_td_heading_and_subsections(section)
            elsif section.is_not_parent_heading
              render_table_tr_td_number(section)
              render_table_tr_td_heading(section)
            end
          end
          write_tag_tr_close
        end
      end
  

      def render_table_tr_td_heading(topic)
        write_tag_td_open(attr_list: "class='heading'")
        render_tag_a_section_heading(topic)
        write_tag_td_close_inline
      end
  

      def render_table_tr_td_heading_and_subsections(topic)
        write_tag_td_open(attr_list: "class='heading'")
        render_tag_a_section_heading(topic, trailing_line_feed: true)
        @destination.margin_indent do
          render_table(topic.sections)
        end
        write_tag_td_close_outline
      end


      def render_table_tr_td_number(topic)
        write_tag_td_open(attr_list: "class='number'")
        render_tag_a_section_number(topic, attr_list: "tabindex='-1'")
        write_tag_td_close_inline
      end
  

      def render_tag_a_section_heading(topic, trailing_line_feed: false)
        href = @href_helper.to_topic(topic)
        write_tag_a_open(href)
        write_text_section_heading(topic)
        write_tag_a_close
        if trailing_line_feed
          write_lf
        end
      end
  

      def render_tag_a_section_number(topic, attr_list: nil)
        href = @href_helper.to_topic(topic)
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
        
  
      def write_tag_li_open
        @destination.write_inline_indented tag_li_open
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
  
  
      def tag_a_open(href_id, attr_list: nil)
        ["<a", "class='document_link'", "href='#{href_id}'", attr_list].compact.join(' ').concat('>')
      end
  
  
      def tag_div_close
        "</div>"
      end


      def tag_div_open
        "<div class='contents' data-text_root_name='#{@text_root_name}' id='#{@html_attr_id}'>"
      end
      
      
      def tag_h1_contents_heading
        "<h1>Contents</h1>"
      end


      def tag_li_close
        "</li>"
      end


      def tag_li_open
        "<li>"
      end


      def tag_ol_close
        "</ol>"
      end


      def tag_ol_open
        "<ol>"
      end


      def tag_table_close
        "</table>"
      end


      def tag_table_open
        "<table class='document_links'>"
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
  
  
      def task_depth_is_within_range(textobject)
        result = nil
        if @item_depth_max == nil
          result = true
        elsif textobject.section_depth <= @item_depth_max
          result = true
        elsif textobject.section_depth > @item_depth_max
          result = false
        end
        result
      end
  
  
    end
  end
end
