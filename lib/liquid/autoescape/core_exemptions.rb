require "liquid/autoescape"

module Liquid
  module Autoescape

    # Core exemptions for all Liquid variables
    #
    # These exemptions are used to build the default exemption list referenced
    # when determining whether variables should be escaped.
    module CoreExemptions

      # A list of all filters that influence escaping
      ESCAPING_FILTERS = [:escape, :skip_escape]

      # Determine whether a Liquid variable uses an escaping filter
      #
      # This accounts for both filters that are known to escape the variable
      # and those that should prevent the variable from being escaped.
      #
      # @param [Liquid::Autoescape::TemplateVariable] A Liquid variable used in a template
      # @return [Boolean]
      def uses_escaping_filter?(variable)
        !(variable.filters & ESCAPING_FILTERS).empty?
      end

      # Determine whether a Liquid variable uses a trusted filters
      #
      # Trusted filters can be configured by the user to include any custom
      # filters that are known to generate already escaped markup.
      #
      # @param [Liquid::Autoescape::TemplateVariable] A Liquid variable used in a template
      # @return [Boolean]
      def uses_trusted_filter?(variable)
        !(variable.filters & Autoescape.configuration.trusted_filters).empty?
      end

    end

  end
end
