require "spec_helper"

describe NyucoresHelper do

  include NyucoresHelper

  describe ".multivalue_fields" do
    subject { multivalue_fields }
    it { should be_instance_of Array }
  end

  describe ".format_field_index" do
    let(:field) { [] }
    let(:index) { nil }

    subject { format_field_index(field, index) }

    context "when index is nil and hence called by the last element" do
      context "when field array is blank" do
        it { should be_nil }
      end

      context "when field array contains a single value" do
        let(:field) { ["Value1"] }
        it { should be 1 }
      end

      context "when field array contains multiple values" do
        let(:field) { ["Value1","Value2"] }
        it { should be 2 }
      end
    end

    context "when index is not nil and hence not the last element" do
      let(:index) { 2 }
      context "when field array is blank" do
        it { should be_nil }
      end

      context "when field array contains values" do
        let(:field) { ["Value1","Value2","Value3"] }
        it { should be 2 }
      end
    end
  end

end
