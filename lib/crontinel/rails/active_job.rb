# frozen_string_literal: true

module Crontinel
  module Rails
    module ActiveJob
      extend ActiveSupport::Concern

      included do
        around_perform do |job, block|
          client = Crontinel.client rescue nil
          return block.call unless client

          task_name = "#{job.class.name}-#{job.job_id}"
          client.task_started(name: task_name)

          start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          begin
            block.call
            duration_ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start) * 1000).to_i
            client.task_finished(name: task_name, duration_ms: duration_ms)
          rescue => e
            duration_ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start) * 1000).to_i
            client.task_failed(name: task_name, error: e.message, duration_ms: duration_ms)
            raise
          end
        end
      end
    end
  end
end
