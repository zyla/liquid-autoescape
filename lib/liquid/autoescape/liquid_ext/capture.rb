require "liquid"
require "liquid/autoescape"
require "liquid/autoescape/template_variable"
require "liquid/autoescape/liquid_ext/standard_filters"

module Liquid
  class Capture
    def render_all(nodelist, context)
      Liquid::Autoescape::SafeString.mark_safe super
    end
  end
end
