# Crontinel Rails

Rails integration for [Crontinel](https://crontinel.com) — open-source monitoring for cron jobs, background workers, and scheduled tasks.

Unlike generic uptime tools, Crontinel knows when a job started but crashed silently, when a queue worker stopped processing, or when a cron fired but did nothing.

## Installation

Add to your `Gemfile`:

```ruby
gem "crontinel-rails", "~> 0.1"
gem "crontinel", "~> 0.1"
```

```bash
bundle install
```

## Configuration

Create `config/initializers/crontinel.rb`:

```ruby
Crontinel.setup do |config|
  config.api_key = ENV.fetch("CRONTINEL_API_KEY")
  config.endpoint = "https://app.crontinel.com/api/v1" # optional
end
```

Or via environment variables:

```bash
CRONTINEL_API_KEY=your_key_here
CRONTINEL_ENDPOINT=https://app.crontinel.com/api/v1  # optional
```

## ActiveJob Integration

Automatically tracks all ActiveJob.perform_later jobs:

```ruby
# Just include the module — it wraps around_perform automatically
class MyJob < ApplicationJob
  include Crontinel::Rails::ActiveJob

  def perform(*args)
    # your job work
  end
end
```

## Sidekiq Integration

Automatically tracks Sidekiq jobs via middleware:

```ruby
# lib/crontinel_rails.rb
require "crontinel/rails/sidekiq/server_middleware"

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    chain.add Crontinel::Rails::Sidekiq::ServerMiddleware
  end
end
```

## Manual Tracking

```ruby
Crontinel.client.task_started(name: "my-cron-job")
# do work...
Crontinel.client.task_finished(name: "my-cron-job", duration_ms: 150)
```

## Supported Rails Versions

Rails 6.1+

## License

MIT © Harun R Rayhan
