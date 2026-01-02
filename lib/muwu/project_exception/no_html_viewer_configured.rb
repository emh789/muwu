module Muwu
  module ProjectException
    class NoHTMLViewerConfigured


      def initialize
        $stderr.puts "#{self.class}"
      end


      def report
        "No HTML viewer configued to run from the 'open' command."
      end


      def type
        :view
      end


    end
  end
end
