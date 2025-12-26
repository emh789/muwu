module Muwu
  module Helper
    module SanitizerHelper
      
      
      require 'cgi'
      
      
      module_function
      
      
      def sanitize_destination_file_basename(basename)
        File.basename(basename.to_s).gsub(/\W/,'_').gsub(/_{2,}/,'_')
      end
      
      
      def sanitize_topic_basename(basename)
        basename.to_s.gsub(RegexpLib.path_two_or_more_dots,'_')
      end
      
            
      def sanitize_topic_path(path)
        case path
        when Array
          return path.map { |p| sanitize_topic_path_segment(p) }
        when Integer, String
          return sanitize_topic_path_segment(path)
        end
      end
      
      
      def sanitize_topic_path_segment(path)
        path.to_s.downcase.gsub(/\s/,'_').gsub(/\W/,'').gsub(/_{2,}/,'_')
      end
    

      def sanitize_metadata(metadata)
        sanitized_metadata = {}
        metadata.each_pair do |k,v|
          key_safe = CGI::escape_html(k.to_s)
          value_safe = CGI::escape_html(v.to_s)
          sanitized_metadata[key_safe] = value_safe
        end
        sanitized_metadata
      end
      
      
    end
  end
end