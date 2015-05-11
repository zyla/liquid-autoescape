require "liquid"
require "liquid/autoescape"
require "liquid/autoescape/template_variable"

module Liquid
  class Variable

    # @private
    alias_method :non_escaping_render, :render

    # Possibly render the variable with HTML escaping applied
    #
    # If the autoescaping context variable has been set by the +autoescape+ tag
    # or Liquid autoescaping is globally enabled, this will run the variable
    # through the global exemption list to determine if it is exempt from
    # autoescaping.  If it is not, its contents will be rendered as a string
    # with all unsafe HTML characters escaped.  In all other cases, the
    # original, unescaped value of the variable will be rendered.
    #
    # @param [Liquid::Context] context The variable's rendering context
    # @return [String] The potentially escaped contents of the variable
    def render(context)
      if !Autoescape.configuration.global? && !context[Autoescape::ENABLED_FLAG]
        return non_escaping_render(context)
      end

      variable = Autoescape::TemplateVariable.from_liquid_variable(self)
      is_exempt = Autoescape.configuration.exemptions.apply?(variable)

      @filters << [:escape, []] unless is_exempt
      output = non_escaping_render(context)
      @filters.pop unless is_exempt

      output
    end

  end
end
