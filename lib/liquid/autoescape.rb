require "liquid/autoescape/configuration"
require "liquid/autoescape/filters"
require "liquid/autoescape/tags/autoescape"

module Liquid
  module Autoescape

    # The context variable that stores the autoescape state
    #
    # @private
    ENABLED_FLAG = "liquid_autoescape_enabled"

    # Configure Liquid autoescaping
    #
    # @yieldparam [Liquid::Autoescape::Configuration] config The autoescape configuration
    def self.configure
      yield(configuration)
    end

    # Restore the configuration's default values
    def self.reconfigure
      configuration.reset
    end

    # The current autoescape configuration
    #
    # @return [Liquid::Autoescape::Configuration]
    def self.configuration
      @configuration ||= Configuration.new
    end

  end
end
