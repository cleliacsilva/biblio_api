require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module BiblioApi
  class Application < Rails::Application
    config.load_defaults 8.1
    config.autoload_lib(ignore: %w[assets tasks])
    config.api_only = true

    config.generators do |g|
      g.test_framework :rspec,
        fixtures: true,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        controller_specs: false,
        request_specs: true
    end

    config.middleware.use Rack::Attack
  end
end
