require "liquid/autoescape/errors"

module Liquid
  module Autoescape
    class Exemption

      # Create a new autoescaping exemption
      #
      # This requires a filter function to be provided that will be passed a
      # +VariableData+ instance that it can use to return a boolean indicating
      # whether the exemption applies to the variable.
      #
      # @param [Proc] filter A filter function to use for calculating the exemption
      # @raise [Liquid::Autoescape::ExemptionError] if a filter function is not provided
      def initialize(&filter)
        raise ExemptionError, "You must provide an exemption with a block that determines if an exemption applies" unless block_given?
        @filter = filter
      end

      # Determine whether the exemption applies to a Liquid variable
      #
      # @param [Liquid::Autoescape::VariableData] A Liquid variable used in a template
      # @return [Boolean] Whether the exemption applies to the variable
      def applies?(variable)
        @filter.call(variable)
      end

    end
  end
end
