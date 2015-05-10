module Liquid
  module Autoescape
    class VariableData

      # @return [String] The name of the variable
      attr_reader :name

      # @return [Array<Symbol>] The filters applied to the variable
      attr_reader :filters

      # Create a new wrapper around a Liquid variable used in a template
      #
      # @options options [String] :name The name of the variable
      # @options options [Array<Symbol>] :filters The filters applied to the variable
      def initialize(options={})
        @name = options.fetch(:name)
        @filters = options[:filters] || []
      end

    end
  end
end
