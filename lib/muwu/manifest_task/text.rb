module Muwu
  module ManifestTask
    class Text


      attr_accessor(
        :destination,
        :naming,
        :numbering,
        :project,
        :sections
      )


      def inspect
        ["#{self.to_s}", "{", inspect_instance_variables, "}"].join(' ')
      end


      def inspect_instance_variables
        self.instance_variables.map { |v| "#{v}=#<#{instance_variable_get(v).class}>" }.join(", ")
      end



      public


      def naming_downcase
        @naming.map {|n| n.downcase}
      end


      def naming_downcase_without_text_root
        naming_without_text_root.map {|n| n.downcase}
      end


      def naming_without_text_root
        @naming[1..-1]
      end


      def text_root_name
        @naming[0]
      end


    end
  end
end
