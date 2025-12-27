module Muwu
  class Manifest


    include Muwu


    attr_accessor(
      :documents,
      :options,
      :project
    )


    def initialize
      @documents = []
    end


    def inspect
      ["#{self.to_s}", "{", inspect_instance_variables, "}"].join(' ')
    end


    def inspect_instance_variables
      self.instance_variables.map { |v| "#{v}=#<#{instance_variable_get(v).class}>" }.join(", ")
    end



    public


    def contents_block_by_name(text_root_name)
      matching_contents = []
      documents_html.each do |document_html|
        matching_contents << document_html.contents_blocks_by_name(text_root_name)
      end
      matching_contents.flatten[0]
    end


    def contents_block_filename_for(text_root_name)
      contents_block = contents_block_by_name(text_root_name)
      if contents_block
        contents_block.destination.output_filename
      end
    end


    def documents_count
      @documents.length
    end


    def documents_css
      @documents.select { |d| ManifestTask::DocumentCss === d }
    end


    def documents_css_count
      documents_css.length
    end


    def documents_html
      @documents.select { |d| ManifestTask::DocumentHtml === d }
    end


    def documents_html_count
      documents_html.length
    end


    def documents_js
      @documents.select { |d| ManifestTask::DocumentJs === d }
    end


    def documents_js_count
      documents_js.length
    end


    def does_have_documents
      documents_count > 0
    end


    def does_have_documents_css
      documents_css_count > 0
    end


    def does_have_documents_html
      documents_html_count > 0
    end


    def does_have_documents_js
      documents_js_count > 0
    end


    def does_not_have_documents
      documents_count == 0
    end


    def find_document_html_by_index(index)
      documents_html.select { |document_html| document_html.index == index }[0]
    end


    def has_contents_for(text_root_name)
      ManifestTask::Contents === contents_block_by_name(text_root_name)
    end


    def text_blocks
      text_blocks = []
      documents_html.each do |document_html|
        text_blocks.concat(document_html.text_blocks)
      end
      text_blocks.flatten
    end


    def text_blocks_by_name(text_root_name)
      matching_text_blocks = []
      documents_html.each do |document_html|
        matching_text_blocks.concat(document_html.text_blocks_by_name(text_root_name))
      end
      matching_text_blocks.flatten
    end


  end
end
