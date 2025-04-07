require_relative "boot"
require_relative '../app/middleware/request_logger'
require_relative '../app/middleware/trace_id_middleware'

require "rails/all"

Bundler.require(*Rails.groups)

module TodoServiceApi
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    # config.autoload_paths << Rails.root.join('app/errors')

    config.api_only = true
    config.middleware.use RequestStore::Middleware
    config.middleware.use TraceIdMiddleware
    config.middleware.use RequestLogger
  end
end
