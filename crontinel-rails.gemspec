# frozen_string_literal: true

version = File.read(File.expand_path('../lib/crontinel/rails/version.rb', __FILE__))[/VERSION\s*=\s*['"]([^'"]+)['"]/, 1]

Gem::Specification.new do |spec|
  spec.name = "crontinel-rails"
  spec.version = version
  spec.authors = ["Harun R Rayhan"]
  spec.email = ["me@harunray.com"]
  spec.summary = "Crontinel integration for Ruby on Rails — monitor cron jobs and background workers"
  spec.description = <<~DESC
    Rails integration for Crontinel — open-source monitoring for cron jobs,
    background jobs, and scheduled tasks. Works with ActiveJob, Sidekiq, Rescue,
    and any custom scheduler.
  DESC
  spec.homepage = "https://crontinel.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7"
  spec.metadata = {
    "homepage_uri" => spec.homepage,
    "source_code_uri" => "https://github.com/crontinel/ruby-on-rails",
    "changelog_uri" => "https://github.com/crontinel/ruby-on-rails/blob/main/CHANGELOG.md",
    "bug_tracker_uri" => "https://github.com/crontinel/ruby-on-rails/issues"
  }

  spec.files = Dir["lib/**/*.rb", "config/**/*.rb", "README.md", "CHANGELOG.md", "LICENSE.txt"]
  spec.require_path = "lib"

  spec.add_dependency "crontinel", "~> 0.1"
  spec.add_dependency "railties", ">= 6.1", "< 8.0"

  spec.add_development_dependency "bundler", ">= 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "rails", "~> 7.0"
  spec.add_development_dependency "sidekiq", "~> 8.1"
  spec.add_development_dependency "rubocop", "~> 1.50"
end
