require "./spec_helper"

describe Bugsnag do
  describe "#notify" do
    key = "API_KEY"

    Spec.before_each do
      Bugsnag.configure do |config|
        config.api_key = key
      end
    end

    it "sends notices" do
      WebMock.stub(:post, "https://notify.bugsnag.com/").
        with(headers: {"Content-Type" => "application/json"})

      retval = Bugsnag.notify(BugsnagTestError.new)
      retval.should be_true
    end

    it "raises error when api_key is missing" do
      Bugsnag.config.api_key = nil

      expect_raises Bugsnag::BugsnagError, ":api_key is required" do
        Bugsnag.notify(BugsnagTestError.new)
      end
    end
  end
end
