require "liquid/autoescape/errors"
require "liquid/autoescape/exemption"
require "liquid/autoescape/template_variable"

module Liquid
  module Autoescape
    describe Exemption do

      it "requires a callable filter block" do
        expect { Exemption.new }.to raise_error(ExemptionError)
        expect { Exemption.new { true } }.to_not raise_error
      end

      describe "#applies?" do

        it "evaluates the filter block in the context of variable data" do
          exemption = Exemption.new { |variable| variable.name == "one" }
          var_one = TemplateVariable.new(:name => "one")
          var_two = TemplateVariable.new(:name => "two")

          expect(exemption.applies?(var_one)).to be(true)
          expect(exemption.applies?(var_two)).to be(false)
        end

      end

    end
  end
end
