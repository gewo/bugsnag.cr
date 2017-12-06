require "http/server/handler"

module Bugsnag
  class HttpHandler
    include HTTP::Handler

    def call(context : HTTP::Server::Context)
      call_next context
    rescue e
      Bugsnag.notify e
      raise e
    end
  end
end
