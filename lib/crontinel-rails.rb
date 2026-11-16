# frozen_string_literal: true

require "crontinel"
require "crontinel/rails/version"

module Crontinel
  module Rails
    autoload :ActiveJob, "crontinel/rails/active_job"

    class << self
      attr_writer :settings

      # Settings from config.crontinel (the engine fills these in), falling back to Crontinel.setup and env.
      def settings
        @settings ||= {}
      end

      # One client for the app, or nil when no API key is configured (reporting is then off).
      def client
        return @client if defined?(@client)

        api_key = settings[:api_key].presence || Crontinel.config.api_key
        endpoint = (settings[:endpoint].presence || Crontinel.config.endpoint).to_s.chomp("/").delete_suffix("/api/v1")
        @client = api_key.present? ? Crontinel.client(api_key: api_key, endpoint: endpoint) : nil
      end

      def reset_client!
        remove_instance_variable(:@client) if defined?(@client)
      end

      # Report one run of a job named by its class. A Crontinel outage never fails the job itself.
      def track(name)
        start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        result = yield
        report { |c| c.task_finished(name: name, duration_ms: elapsed_ms(start)) }
        result
      rescue Exception => e # rubocop:disable Lint/RescueException -- re-raised; only reports first
        report { |c| c.task_failed(name: name, error: e.message, duration_ms: elapsed_ms(start)) } if start
        raise
      end

      private

      def elapsed_ms(start)
        ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start) * 1000).to_i
      end

      def report
        c = client
        yield c if c
      rescue StandardError => e
        warn "[crontinel-rails] could not report run: #{e.class}: #{e.message}"
      end
    end
  end
end

require "crontinel/rails/engine" if defined?(Rails::Engine)
