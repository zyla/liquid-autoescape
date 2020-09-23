module Liquid
  module Autoescape
    class SafeString < String
      def self.mark_safe(str)
        if self.is_safe? str
          return str
        else
          return self.new(str)
        end
      end

      def self.is_safe?(str)
        str.is_a? SafeString
      end
    end
  end
end
