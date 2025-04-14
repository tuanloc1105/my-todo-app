require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module TodoServiceApi
  class Application < Rails::Application
    config.time_zone = "Asia/Ho_Chi_Minh"
    config.load_defaults 8.0
    config.encoding = "utf-8"
    config.autoload_lib(ignore: %w[assets tasks])

    # config.autoload_paths << Rails.root.join('app/errors')

    config.api_only = true
    config.middleware.use RequestStore::Middleware
    config.middleware.use CommonLib::TraceIdMiddleware
    config.middleware.use CommonLib::RequestLogger
  end
end
