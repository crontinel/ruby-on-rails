# frozen_string_literal: true

module Crontinel
  module Rails
    module ActiveJob
      extend ActiveSupport::Concern

      included do
        around_perform do |job, block|
          Crontinel::Rails.track(job.class.name) { block.call }
        end
      end
    end
  end
end
