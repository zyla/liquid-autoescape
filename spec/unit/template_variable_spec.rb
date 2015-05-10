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

      it "can accept variable names describing a lookup" do
        data = TemplateVariable.new(:name => "hash.key")
        expect(data.name).to eq("hash.key")
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

        it "creates a wrapper around a Liquid variable describing a lookup" do
          liquid_variable = Liquid::Variable.new("hash.key")
          wrapper = TemplateVariable.from_liquid_variable(liquid_variable)

          expect(wrapper.name).to eq("hash.key")
        end

        it "creates a wrapper around a Liquid variable describing a deep lookup" do
          liquid_variable = Liquid::Variable.new("trunk.branch.leaf")
          wrapper = TemplateVariable.from_liquid_variable(liquid_variable)

          expect(wrapper.name).to eq("trunk.branch.leaf")
        end

      end

    end
  end
end
