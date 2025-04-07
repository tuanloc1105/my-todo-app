require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module TodoServiceApi
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    # config.autoload_paths << Rails.root.join('app/errors')

    config.api_only = true
  end
end
