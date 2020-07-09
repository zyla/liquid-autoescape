require "liquid"
require "liquid/autoescape"
require "liquid/autoescape/template_variable"
require "liquid/autoescape/liquid_ext/standard_filters"

module Liquid
  class Block
    alias non_escaping_render_token render_token

    def render_token(token, context)
      output = non_escaping_render_token(token, context)

      if !token.is_a? Variable
        return output
      end

      if !Autoescape.configuration.global? && !context[Autoescape::ENABLED_FLAG]
        return output
      end

      variable = Autoescape::TemplateVariable.from_liquid_variable(token)
      is_exempt = Autoescape.configuration.exemptions.apply?(variable)

      if is_exempt
        return output
      end

      Liquid::StandardFilters.escape(output)
    end
  end
end
