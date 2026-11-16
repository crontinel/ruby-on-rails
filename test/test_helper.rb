# frozen_string_literal: true

require "minitest/autorun"
require "minitest/reporters"
require "active_support"
require "active_support/ordered_options"
require "rails"
require "crontinel-rails"
require "crontinel/rails/sidekiq/server_middleware"

Minitest::Reporters.use!
