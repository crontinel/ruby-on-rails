# frozen_string_literal: true

require "test_helper"

describe Crontinel::Rails do
  describe ".VERSION" do
    it "is defined" do
      refute_nil Crontinel::Rails::VERSION
    end
  end
end

describe Crontinel::Rails::Railtie do
  describe "configuration" do
    it "allows setting api_key via config" do
      config = ActiveSupport::OrderedOptions.new
      config.api_key = "test_key"
      config.endpoint = "https://app.crontinel.com/api/v1"
      config.enabled = true

      assert_equal "test_key", config.api_key
      assert_equal "https://app.crontinel.com/api/v1", config.endpoint
      assert_equal true, config.enabled
    end
  end
end
