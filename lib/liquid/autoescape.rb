require "liquid/autoescape/filters"
require "liquid/autoescape/tags/autoescape"
require "liquid/autoescape/variable"

module Liquid
  module Autoescape

    # The context variable that stores the autoescape state
    ENABLED_FLAG = "liquid_autoescape_enabled"

  end
end
