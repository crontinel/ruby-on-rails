# frozen_string_literal: true

module Crontinel
  module Rails
    module Sidekiq
      class ServerMiddleware
        def call(worker, msg, queue)
          client = Crontinel.client rescue nil
          task_name = "#{worker.class.name}-#{msg["jid"]}"

          if client
            client.task_started(name: task_name)
          end

          start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          begin
            yield
            if client
              duration_ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start) * 1000).to_i
              client.task_finished(name: task_name, duration_ms: duration_ms)
            end
          rescue => e
            if client
              duration_ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start) * 1000).to_i
              client.task_failed(name: task_name, error: e.message, duration_ms: duration_ms)
            end
            raise
          end
        end
      end
    end
  end
end
