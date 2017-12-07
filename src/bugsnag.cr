require "json"
require "http/client"

require "./bugsnag/*"

module Bugsnag
  def self.notify(exception)
    unless config.api_key
      raise BugsnagError.new(":api_key is required")
    end

    send_payload(build_notice(exception))
  end

  def self.configure
    @@configuration = Config.new
    yield config
  end

  def self.config
    @@configuration ||= Config.new
  end

  private def self.build_notice(exception)
    Notice.new(exception)
  end

  private def self.send_payload(notice)
    Sender.send(notice)
  end

  module Backtrace
    # Examples:
    #   *raise<String>:NoReturn +70 [0]
    #   *Crystal::CodeGenVisitor#visit<Crystal::CodeGenVisitor, Crystal::Assign>:(Nil | Bool) +534 [0]
    STACKFRAME_TEMPLATE = /\A(.+)? (\d+):\d+\z/

    def self.parse(exception)
      (exception.backtrace || [] of String).map do |stackframe|
        if m = stackframe.match(STACKFRAME_TEMPLATE)
          {
            file:       m[1]? || "<crystal>",
            lineNumber: m[2]?.try(&.to_i) || 0,
            method:     "<file>",
          }
        else
          {file: stackframe, lineNumber: 0, method: "<file>"}
        end
      end || [] of {file: String, lineNumber: Int32, method: String}
    end
  end

  class Notice
    def initialize(exception)
      @payload = {
        apiKey:   Bugsnag.config.api_key || "",
        notifier: {
          name:    "Bugsnag Crystal",
          version: Bugsnag::VERSION,
          url:     "https://github.com/gewo/bugsnag.cr",
        },
        events: [{
          payloadVersion: "4",
          app: {
            releaseStage: Bugsnag.config.release_stage || "production"
          },
          exceptions:     [{
            errorClass: exception.class.name || "",
            message:    exception.message || "",
            stacktrace: Backtrace.parse(exception),
          }],
        }],
      }
    end

    def to_json(io)
      @payload.to_json(io)
    end
  end

  class Config
    property api_key : String?
    property endpoint = "https://notify.bugsnag.com"
    property release_stage = "production"

    def uri
      URI.parse(endpoint.to_s)
    end
  end

  module Sender
    def self.send(notice)
      response = HTTP::Client.post(
        Bugsnag.config.uri,
        headers: HTTP::Headers{
          "Content-Type" => "application/json",
          "User-Agent"   => "Bugsnag Crystal",
        },
        body: notice.to_json)

      response.success?
    end
  end

  class BugsnagError < Exception
  end
end
