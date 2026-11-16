# frozen_string_literal: true

module Crontinel
  module Rails
    class Engine < ::Rails::Engine
      config.crontinel = ActiveSupport::OrderedOptions.new
      config.crontinel.enabled = true

      initializer "crontinel.configure" do |app|
        cfg = app.config.crontinel
        Crontinel::Rails.settings = { api_key: cfg.api_key, endpoint: cfg.endpoint || ENV["CRONTINEL_ENDPOINT"] }
        Crontinel::Rails.reset_client!
      end

      initializer "crontinel.rails.active_job" do |app|
        next unless app.config.crontinel.enabled

        ActiveSupport.on_load(:active_job) { include Crontinel::Rails::ActiveJob }
      end

      initializer "crontinel.rails.sidekiq" do |app|
        next unless app.config.crontinel.enabled && defined?(::Sidekiq) && defined?(::Sidekiq::Middleware)

        require "crontinel/rails/sidekiq/server_middleware"
        ::Sidekiq.configure_server do |config|
          config.server_middleware { |chain| chain.add Crontinel::Rails::Sidekiq::ServerMiddleware }
        end
      end
    end
  end
end
