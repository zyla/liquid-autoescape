require "liquid/autoescape/variable_data"

module Liquid
  module Autoescape
    describe VariableData do

      it "requires a variable name" do
        expect { VariableData.new }.to raise_error(KeyError)
        expect { VariableData.new(:name => "Variable") }.to_not raise_error
      end

      it "exposes its variable name" do
        data = VariableData.new(:name => "Variable")
        expect(data.name).to eq("Variable")
      end

      it "can accept a list of filters applied to the variable" do
        data = VariableData.new(:name => "Variable", :filters => [:downcase])
        expect(data.filters).to match_array([:downcase])
      end

    end
  end
end
