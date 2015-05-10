module Liquid
  module Autoescape
    class VariableData

      # @return [String] The name of the variable
      attr_reader :name

      # @return [Array<Symbol>] The filters applied to the variable
      attr_reader :filters

      # Create a wrapper for a Liquid variable instance
      #
      # This normalizes the variable's information, since Liquid 2 and 3 handle
      # variable names using different data structures.
      #
      # @param [Liquid::Variable] variable A Liquid variable as used in a template
      # @return [Liquid::Autoescape::VariableData]
      def self.from_liquid_variable(variable)
        name = variable.name.instance_variable_get("@name") || variable.name
        filters = variable.filters.map { |f| f.first.to_sym }

        new(:name => name, :filters => filters)
      end

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
