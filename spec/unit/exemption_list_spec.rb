require "liquid/autoescape/exemption_list"
require "liquid/autoescape/template_variable"

module Liquid
  module Autoescape
    describe ExemptionList do

      let(:exemptions) { ExemptionList.new }

      describe ".from_module" do

        it "creates a new exemption list with the module's methods as exemptions" do
          custom = Module.new do
            def exemption_one(variable)
              variable.name == "one"
            end

            def exemption_two(variable)
              variable.name == "two"
            end
          end

          from_module = ExemptionList.from_module(custom)
          expect(from_module).to be_an_instance_of(ExemptionList)
          expect(from_module.size).to eq(2)
        end

      end

      describe "#add" do

        it "adds a filter function as an exemption" do
          expect(exemptions.size).to eq(0)
          exemptions.add { |variable| variable.name == "variable" }
          expect(exemptions.size).to eq(1)
        end

        it "is chainable" do
          first = lambda { |variable| variable.name == "one" }
          second = lambda { |variable| variable.name == "two" }

          expect(exemptions.size).to eq(0)
          exemptions.add(&first).add(&second)
          expect(exemptions.size).to eq(2)
        end

      end

      describe "#add_module" do

        it "adds all instance methods from a module as exemptions" do
          custom = Module.new do
            def exemption(variable)
              variable.name == "variable"
            end
          end

          expect(exemptions.size).to eq(0)
          exemptions.add_module(custom)
          expect(exemptions.size).to eq(1)
        end

        it "adds methods with identical names from different modules" do
          module_one = Module.new do
            def exemption(variable)
              variable.name == "one"
            end
          end

          module_two = Module.new do
            def exemption(variable)
              variable.name == "two"
            end
          end

          expect(exemptions.size).to eq(0)
          exemptions.add_module(module_one)
          exemptions.add_module(module_two)
          expect(exemptions.size).to eq(2)
        end

        it "is chainable" do
          custom = Module.new do
            def exemption(variable)
              variable.name == "one"
            end
          end

          expect(exemptions.size).to eq(0)
          exemptions.add_module(custom).add_module(custom)
          expect(exemptions.size).to eq(2)
        end

      end

      describe "#apply?" do

        let(:var_one) { TemplateVariable.new(:name => "one") }
        let(:var_two) { TemplateVariable.new(:name => "two") }

        it "returns true when a filter function applies to a variable" do
          expect(exemptions.apply?(var_one)).to be(false)
          expect(exemptions.apply?(var_two)).to be(false)

          exemptions.add { |variable| variable.name == "one" }

          expect(exemptions.apply?(var_one)).to be(true)
          expect(exemptions.apply?(var_two)).to be(false)
        end

        it "returns true when a module function applies to a variable" do
          custom = Module.new do
            def exemption(variable)
              variable.name == "one"
            end
          end

          expect(exemptions.apply?(var_one)).to be(false)
          expect(exemptions.apply?(var_two)).to be(false)

          exemptions.add_module(custom)

          expect(exemptions.apply?(var_one)).to be(true)
          expect(exemptions.apply?(var_two)).to be(false)
        end

      end

      describe "#populated?" do

        it "is false when there are no exemptions" do
          expect(exemptions.populated?).to be(false)
        end

        it "is true when there are exemptions" do
          exemptions.add { true }
          expect(exemptions.populated?).to be(true)
        end

      end

      describe "#size" do

        it "is zero when there are no exemptions" do
          expect(exemptions.size).to eq(0)
        end

        it "is true when there are exemptions" do
          exemptions.add { true }
          expect(exemptions.size).to eq(1)
        end

      end

    end
  end
end
