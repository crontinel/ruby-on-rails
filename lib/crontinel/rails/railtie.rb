# frozen_string_literal: true

module Crontinel
  module Rails
    class Railtie < ::Rails::Railtie
      config.crontinel = ActiveSupport::OrderedOptions.new

      generator_commands :crontinel do
        {
          api_key: ENV["CRONTINEL_API_KEY"]
        }
      end

      rake_tasks do
        require "crontinel/rails/tasks"
      end
    end
  end
end
