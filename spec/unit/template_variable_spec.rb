require "liquid"
require "liquid/autoescape/template_variable"

module Liquid
  module Autoescape
    describe TemplateVariable do

      it "requires a variable name" do
        expect { TemplateVariable.new }.to raise_error(KeyError)
        expect { TemplateVariable.new(:name => "variable") }.to_not raise_error
      end

      it "exposes its variable name" do
        data = TemplateVariable.new(:name => "variable")
        expect(data.name).to eq("variable")
      end

      it "can accept a list of filters applied to the variable" do
        data = TemplateVariable.new(:name => "variable", :filters => [:downcase])
        expect(data.filters).to match_array([:downcase])
      end

      describe ".from_liquid_variable" do

        it "creates a wrapper around an unfiltered Liquid variable" do
          liquid_variable = Liquid::Variable.new("from_liquid")
          wrapper = TemplateVariable.from_liquid_variable(liquid_variable)

          expect(wrapper.name).to eq("from_liquid")
          expect(wrapper.filters).to be_empty
        end

        it "creates a wrapper around a filtered Liquid variable" do
          liquid_variable = Liquid::Variable.new("from_liquid | downcase | capitalize")
          wrapper = TemplateVariable.from_liquid_variable(liquid_variable)

          expect(wrapper.name).to eq("from_liquid")
          expect(wrapper.filters).to eq([:downcase, :capitalize])
        end

      end

    end
  end
end
