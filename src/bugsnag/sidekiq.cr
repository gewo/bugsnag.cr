require "sidekiq/middleware"

module Bugsnag
  class Sidekiq < Sidekiq::Middleware::ServerEntry
    def call(job, ctx)
      yield
    rescue e
      Bugsnag.notify e
      raise e
    end
  end
end
