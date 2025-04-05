# frozen_string_literal: true
if Rails.env.production?
  Sentry.init do |config|
    config.dsn = ENV['SENTRY_DSN']
    config.breadcrumbs_logger = [:active_support_logger, :http_logger]
    config.traces_sample_rate = 1.0
    # Add data like request headers and IP for users,
    # see https://docs.sentry.io/platforms/ruby/data-management/data-collected/ for more info
    config.send_default_pii = true
  end
else
  # Define a mock Sentry module for non-production environments to avoid errors
  module Sentry
    def self.get_trace_propagation_meta
      ""
    end
  end
end
