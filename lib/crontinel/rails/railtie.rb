# frozen_string_literal: true

module Crontinel
  module Rails
    class Railtie < ::Rails::Railtie
      config.crontinel = ActiveSupport::OrderedOptions.new

      initializer "crontinel.configure" do |app|
        api_key = app.config.crontinel.api_key || ENV["CRONTINEL_API_KEY"]
        Crontinel.configure { |c| c.api_key = api_key } if api_key && defined?(Crontinel)
      end

      rake_tasks do
        require "crontinel/rails/tasks"
      end
    end
  end
end
