require "./spec_helper"

describe Bugsnag::Sidekiq do
  describe "#call" do
    key = "API_KEY"

    Spec.before_each do
      Bugsnag.configure do |config|
        config.api_key = key
      end
    end

    it "runs the job" do
      retval = Bugsnag::Sidekiq.new.call(nil, nil) do
        "done"
      end

      retval.should eq "done"
    end

    it "notifies bugsnag about exceptions" do
      WebMock.stub(:post, "https://notify.bugsnag.com/")
             .with(headers: {"Content-Type" => "application/json"})

      begin
        Bugsnag::Sidekiq.new.call(nil, nil) do
          raise "Errr!"
          "done"
        end
      rescue e
        e.message.should eq "Errr!"
      end
    end
  end
end
