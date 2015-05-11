require "liquid/autoescape"
require "liquid/autoescape/exemption"

module Liquid
  module Autoescape

    # A list of exemptions that may apply to template variables
    #
    # Exemption lists manage one or more exemptions, and determine whether any
    # managed exemptions applies to a template variable.  Exemptions can be
    # added as individual filter functions, or can be imported in bulk from a
    # module.
    #
    # @example Adding exemption functions
    #   exemptions = ExemptionList.new
    #   ExemptionList.add { |variable| variable.name == "one" }
    #   ExemptionList.add { |variable| variable.name == "two" }
    #
    # @example Importing exemptions from a module
    #   module MyExemptions
    #
    #     def exemption_one(variable)
    #       variable.name == "one"
    #     end
    #
    #     def exemption_two(variable)
    #       variable.name == "two"
    #     end
    #
    #   end
    #
    #   exemptions = ExemptionList.new
    #   exemptions.add_module(MyExemptions)
    #
    class ExemptionList

      # Create an exemption list from a module's instance methods
      #
      # @param [Module] source The module providing exemptions as methods
      # @return [Liquid::Autoescape::ExemptionList]
      def self.from_module(source)
        exemptions = new
        exemptions.add_module(source)
        exemptions
      end

      # Create a new exemption list
      def initialize
        @exemptions = []
      end

      # Add a single filter function to use as an exemption
      #
      # @param [Proc] filter A filter function to use as an exemption
      # @return [Liquid::Autoescape::ExemptionList] The updated exemption list
      def add(&filter)
        @exemptions << Exemption.new(&filter)
        self
      end

      # Add all instance methods of a module as exemptions
      #
      # @param [Module] source The module providing exemptions as methods
      # @return [Liquid::Autoescape::ExemptionList] The updated exemption list
      def add_module(source)
        container = Module.new { extend source }
        exemptions = source.instance_methods(false)
        exemptions.each do |exemption|
          @exemptions << Exemption.new(&container.method(exemption))
        end
        self
      end

      # Determine whether any of the exemptions apply to a Liquid variable
      #
      # @param [Liquid::Autoescape::TemplateVariable] variable A Liquid variable used in a template
      # @return [Boolean] Whether any of the exemptions apply to the variable
      def applies?(variable)
        @exemptions.each do |exemption|
          if exemption.applies?(variable)
            return true
          end
        end
        false
      end

      alias_method :apply?, :applies?

      # Whether the exemption list has exemptions
      #
      # @return [Boolean]
      def populated?
        !@exemptions.empty?
      end

      # The number of exemptions in the list
      #
      # @return [Integer]
      def size
        @exemptions.size
      end

    end

  end
end
