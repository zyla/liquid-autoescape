require "liquid/autoescape/configuration"

module Liquid
  module Autoescape
    describe Configuration do

      let(:config) { Configuration.new }

      describe "global mode" do

        it "is off by default" do
          expect(config.global?).to be(false)
        end

        it "can be turned on" do
          config.global = true
          expect(config.global?).to be(true)
        end

      end

      describe "the list of custom exemptions" do

        it "has default exemptions" do
          expect(config.exemptions.populated?).to be(true)
        end

        it "can accept custom exemption filters" do
          expect { config.exemptions.add { true } }.to change { config.exemptions.size }.by(1)
        end

        it "cannot directly set exemption filters" do
          exemption = lambda { true }
          expect { config.exemptions << exemption }.to raise_error(NoMethodError)
        end

      end

      describe "the list of trusted filters" do

        it "is empty by default" do
          expect(config.trusted_filters).to be_empty
        end

        it "can receive additional filters" do
          config.trusted_filters << :downcase
          expect(config.trusted_filters).to match_array([:downcase])
        end

      end

      describe "#reset" do

        it "restores the default configuration values" do
          config.global = true
          config.exemptions.add { true }
          config.trusted_filters << :downcase

          expect(config.global?).to be(true)
          expect(config.trusted_filters.size).to be(1)

          expect { config.reset }.to change { config.exemptions.size }.by(-1)

          expect(config.global?).to be(false)
          expect(config.trusted_filters).to be_empty
        end

      end

    end
  end
end
