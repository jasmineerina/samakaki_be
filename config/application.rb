require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SamaKaki
  class Application < Rails::Application
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Flash
    config.middleware.use Rack::MethodOverride
    config.middleware.use ActionDispatch::Session::CookieStore, {:key=>"_sama_kaki_session"}
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Jakarta"
    # config.eager_load_paths << Rails.root.join("extras")

    config.api_only = true
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'

        resource "*",
        headers: :any,
        methods: [:get, :post, :put, :patch, :delete, :options, :head]
      end
    end
  end
end
