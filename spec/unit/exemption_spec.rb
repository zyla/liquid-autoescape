require "liquid/autoescape/errors"
require "liquid/autoescape/exemption"
require "liquid/autoescape/variable_data"

module Liquid
  module Autoescape
    describe Exemption do

      it "requires a callable filter block" do
        expect { Exemption.new }.to raise_error(ExemptionError)
        expect { Exemption.new { true } }.to_not raise_error
      end

      describe "#applies?" do

        it "evaluates the filter block in the context of variable data" do
          exemption = Exemption.new { |variable| variable.name == "One" }
          var_one = VariableData.new(:name => "One")
          var_two = VariableData.new(:name => "Two")

          expect(exemption.applies?(var_one)).to be(true)
          expect(exemption.applies?(var_two)).to be(false)
        end

      end

    end
  end
end