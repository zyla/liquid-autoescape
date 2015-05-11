module Liquid
  module Autoescape

    # The base error from which all other autoescape errors inherit
    class AutoescapeError < StandardError; end

    # An error raised when an exemption encounters an issue
    class ExemptionError < AutoescapeError; end

  end
end
