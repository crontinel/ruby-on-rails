# frozen_string_literal: true

require "crontinel/rails/version"
require "crontinel/rails/engine"
require "crontinel/rails/railtie" if defined?(Rails::Railtie)

module Crontinel
  module Rails
    autoload :Railtie, "crontinel/rails/railtie"
    autoload :Middleware, "crontinel/rails/middleware"
    autoload :ActiveJob, "crontinel/rails/active_job"
    autoload :Sidekiq, "crontinel/rails/sidekiq"
  end
end
