# Crontinel Rails

Rails integration for [Crontinel](https://crontinel.com) — open-source monitoring for cron jobs, background workers, and scheduled tasks.

Unlike generic uptime tools, Crontinel knows when a job started but crashed silently, when a queue worker stopped processing, or when a cron fired but did nothing.

## Installation

Add to your `Gemfile`:

```ruby
gem "crontinel-rails", "~> 0.1.1"
```

```bash
bundle install
```

## Configuration

Set your app's ingest key. That is all most apps need:

```bash
CRONTINEL_API_KEY=your_key_here
CRONTINEL_ENDPOINT=https://app.crontinel.com  # optional, for self-hosted
```

Or in `config/application.rb`:

```ruby
config.crontinel.api_key = ENV["CRONTINEL_API_KEY"]
config.crontinel.enabled = true # set false to turn reporting off
```

Without an API key the gem reports nothing and your jobs run as usual.

## What it reports

- **Active Job:** every job reports one run when `perform` finishes, named by the job class (`NightlyReportJob`). An exception reports a failed run and is re-raised.
- **Sidekiq:** plain Sidekiq workers report the same way through server middleware, added automatically. Active Job jobs on Sidekiq report once, not twice.

If Crontinel is unreachable, the gem logs a warning and your job's result is unchanged.

Runs are sent over the MCP endpoint and carry no outcome metrics. To alert when a job finished but did nothing, send the [HTTP check-in receipt](https://docs.crontinel.com/check-in/recipes/) with a count from inside the job.

## Manual tracking

```ruby
Crontinel::Rails.track("nightly-import") do
  # your work
end
```

## Supported Rails Versions

Rails 6.1+

## License

MIT © Harun R Rayhan
