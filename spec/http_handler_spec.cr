require "./spec_helper"

def test_context : HTTP::Server::Context
  request = HTTP::Request.new("GET", "/")
  response = HTTP::Server::Response.new(IO::Memory.new)
  HTTP::Server::Context.new(request, response)
end

class TestNext
  include HTTP::Handler

  getter called
  @called = false

  def call(context : HTTP::Server::Context)
    @called = true
  end
end

class TestRaiseNext
  include HTTP::Handler

  getter called
  @called = false

  def call(context : HTTP::Server::Context)
    raise("narf")
    @called = true
  end
end

describe Bugsnag::HttpHandler do
  describe "#call" do
    Spec.before_each do
      WebMock.reset
      Bugsnag.configure do |config|
        config.api_key = "API_KEY"
      end
    end

    it "responds normally" do
      context = test_context
      next_handler = TestNext.new

      handler = Bugsnag::HttpHandler.new
      handler.next = next_handler

      handler.call(context)

      next_handler.called.should be_true
    end

    it "notifies bugsnag" do
      # WebMock
      #   .stub(:post, "https://notify.bugsnag.com/")
      #   .with(headers: {"Content-Type" => "application/json"})

      context = test_context
      next_handler = TestRaiseNext.new

      handler = Bugsnag::HttpHandler.new
      handler.next = next_handler

      expect_raises(
        Exception,
        /Unregistered request: POST https:\/\/notify.bugsnag.com/
      ) do
        handler.call(context)
      end

      next_handler.called.should be_false
    end
  end
end
