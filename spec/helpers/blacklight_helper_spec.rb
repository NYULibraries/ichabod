require "spec_helper"
describe BlacklightHelper do
  describe ".field_value_separator" do
    subject { field_value_separator }
    it { should eql("<br />") }
  end
end
