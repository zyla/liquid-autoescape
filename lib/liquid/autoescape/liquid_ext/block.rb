require "liquid"
require "liquid/autoescape"
require "liquid/autoescape/template_variable"
require "liquid/autoescape/safe_string"

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

      escape_if_unsafe(output)
    end

    private

    def escape_if_unsafe(str)
      if Liquid::Autoescape::SafeString.is_safe? str
        str.to_s
      else
        Liquid::StandardFilters.escape(str)
      end
    end
  end
end
