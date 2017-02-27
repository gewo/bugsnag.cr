# bugsnag.cr

[![Build
Status](https://travis-ci.org/gewo/bugsnag.cr.svg)](https://travis-ci.org/gewo/bugsnag.cr/)

Minimal [bugsnag][] exception notifier and [sidekiq.cr][]
middleware for [crystal][].

[bugsnag.cr][] is heavily inspired by (read: stolen)
[airbrake-crystal][]. Thanks.

## Usage

Reporting handled exceptions:

    begin
      raise 'Something went wrong!'
    rescue => exception
      Bugsnag.notify(exception)
    end

sidekiq middleware:

    cli = Sidekiq::CLI.new
    server = cli.configure do |config|
      config.server_middleware.add Bugsnag::Sidekiq.new
    end

## Configuration

    require "bugsnag"

    Bugsnag.configure do |config|
      config.api_key = 'YOUR_API_KEY_HERE'
    end

## Installation

Add [bugsnag.cr][bugsnag.cr] as a dependency in `shards.yml`

    dependencies:
      bugsnag:
        github: gewo/bugsnar.cr
        branch: master

Run `shards update` to download.

[bugsnag.cr]: https://github.com/gewo/bugsnag.cr/
[bugsnag]: https://bugsnag.com/
[crystal]: https://crystal-lang.org/
[sidekiq.cr]: https://github.com/mperham/sidekiq.cr/
[airbrake-crystal]: https://github.com/kyrylo/airbrake-crystal/
