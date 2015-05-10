require "liquid/autoescape"
require "liquid/autoescape/core_exemptions"
require "liquid/autoescape/variable_data"

module Liquid
  module Autoescape
    describe CoreExemptions do

      let(:exemptions) { Module.new { extend CoreExemptions } }

      let(:variable) { VariableData.new(:name => name, :filters => filters) }
      let(:name) { "variable" }
      let(:filters) { [] }

      describe ".uses_escaping_filter?" do

        subject { exemptions.uses_escaping_filter?(variable) }

        context "when no filters are used" do
          let(:filters) { [] }
          it { should be(false) }
        end

        context "when the escape filter is used" do
          let(:filters) { [:escape] }
          it { should be(true) }
        end

        context "when the skip_escape filter is used" do
          let(:filters) { [:skip_escape] }
          it { should be(true) }
        end

        context "when a non-escaping filter is used" do
          let(:filters) { [:downcase] }
          it { should be(false) }
        end

        context "when an escaping filter is used with a non-escaping filter" do
          let(:filters) { [:downcase, :escape] }
          it { should be(true) }
        end

      end

      describe ".uses_trusted_filter?" do

        subject { exemptions.uses_trusted_filter?(variable) }

        before(:each) do
          Autoescape.configure { |config| config.trusted_filters << :downcase }
        end

        after(:each) do
          Autoescape.reconfigure
        end

        context "when a trusted filter is used" do
          let(:filters) { [:downcase] }
          it { should be(true) }
        end

        context "when a non-trusted filter is used" do
          let(:filters) { [:capitalize] }
          it { should be(false) }
        end

      end

    end
  end
end
