require "liquid"
require "liquid/autoescape"

module Liquid
  class Variable

    # A list of all filters that should cause autoescaping to be skipped
    SKIP_FILTERS = [:escape, :skip_escape]

    alias_method :original_render, :render

    def render(context)
      return original_render(context) unless context[Autoescape::ENABLED_FLAG]

      # Add the escape filter to the chain if no skipping filters are found
      filter_names = @filters.map { |f| f.first.to_sym }
      should_escape = (filter_names & SKIP_FILTERS).empty?
      if should_escape
        @filters << [:escape, []]
      end

      output = original_render(context)

      # Clean up by removing the escape filter from the chain after rendering
      if should_escape
        @filters.pop
      end

      output
    end

  end
end
