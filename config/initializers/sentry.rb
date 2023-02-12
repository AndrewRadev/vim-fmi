Sentry.init do |config|
  config.enabled_environments = %w[production]
  config.send_client_reports = false

  config.dsn = 'https://0a42739d26424637a138f5d44c0c923b@o4504668591161344.ingest.sentry.io/4504668594241536'
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |context|
    true
  end
end
