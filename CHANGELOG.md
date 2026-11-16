# Changelog

## [0.1.1] - 2026-11-16

- Fix: jobs now report. 0.1.0 called `Crontinel.client` with no key, which always raised and was swallowed, so nothing was sent.
- Fix: the default endpoint no longer points at `/api/v1/api/mcp` (404). A configured `/api/v1` suffix is dropped.
- Runs are named by job class, not `Class-<job_id>`, so they group as one job.
- Each run reports once (no separate start call that recorded an extra finished run).
- A Crontinel outage no longer fails the job.
- Removed the Railtie's rake task hook, which required a missing file.

## [0.1.0] - 2026-04-18

- Initial release
- ActiveJob integration via around_perform
- Sidekiq server middleware
- Rails Railtie configuration
- Minitest test suite
