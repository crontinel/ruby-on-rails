# frozen_string_literal: true

module Crontinel
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Crontinel::Rails

      config.crontinel = ActiveSupport::OrderedOptions.new

      config.crontinel.api_key = ENV["CRONTINEL_API_KEY"]
      config.crontinel.endpoint = ENV.fetch("CRONTINEL_ENDPOINT", "https://app.crontinel.com/api/v1")
      config.crontinel.enabled = true
      config.crontinel.log_level = :info

      initializer "crontinel.configure_defaults" do |app|
        next unless app.config.crontinel.enabled

        app.config.crontinel.api_key ||= ENV["CRONTINEL_API_KEY"]
        app.config.crontinel.endpoint ||= "https://app.crontinel.com/api/v1"

        Crontinel.client(
          api_key: app.config.crontinel.api_key,
          endpoint: app.config.crontinel.endpoint
        )
      end

      initializer "crontinel.rails.active_job" do
        ActiveSupport.on_load(:active_job) do
          include Crontinel::Rails::ActiveJob
        end
      end

      initializer "crontinel.rails.sidekiq" do
        next unless defined?(Sidekiq)

        Sidekiq.configure_server do |config|
          config.server_middleware do |chain|
            chain.add Crontinel::Rails::Sidekiq::ServerMiddleware
          end
        end
      end
    end
  end
end
