# frozen_string_literal: true

module Crontinel
  module Rails
    module Sidekiq
      class ServerMiddleware
        def call(worker, msg, _queue, &block)
          # Active Job jobs run through Sidekiq report from their own around_perform.
          return yield if msg["wrapped"]

          Crontinel::Rails.track(worker.class.name, &block)
        end
      end
    end
  end
end
