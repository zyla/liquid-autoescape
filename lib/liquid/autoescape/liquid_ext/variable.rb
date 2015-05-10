require "liquid"
require "liquid/autoescape"
require "liquid/autoescape/variable_data"

module Liquid
  class Variable

    alias_method :original_render, :render

    def render(context)
      if !Autoescape.configuration.global? && !context[Autoescape::ENABLED_FLAG]
        return original_render(context)
      end

      # Determine if the variable is exempt from being escaped
      filter_names = @filters.map { |f| f.first.to_sym }
      variable = Autoescape::VariableData.new(:name => @name, :filters => filter_names)
      is_exempt = Autoescape.configuration.exemptions.apply?(variable)

      # Add the escape filter to the chain unless the variable is exempt
      unless is_exempt
        @filters << [:escape, []]
      end

      output = original_render(context)

      # Clean up by removing the escape filter from the chain after rendering
      unless is_exempt
        @filters.pop
      end

      output
    end

  end
end
