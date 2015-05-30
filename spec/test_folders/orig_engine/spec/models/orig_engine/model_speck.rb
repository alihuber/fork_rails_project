# File is named "*.speck" to prevent it from being run by real RSpec tests
# == Schema Information
#
# Table name: orig_engine_models
#
#  id                    :integer          not null, primary key
#  name                  :string

require "spec_helper"

module OrigEngine
  describe Model do
    it "has a valid factory" do
      expect {
        described_class.create!({name: "FooModel"})
      }.not_to raise_error
    end
  end
end
