require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Pinster
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # Enable the asset pipeline
    # config.assets.enabled = true

    # # Version of your assets, change this if you want to expire all your assets
    # config.assets.version = '1.0'

    
    # config.action_mailer.default_url_options = { :host => 'www.talenda.in' }
    # config.action_mailer.perform_deliveries = true
    # config.action_mailer.raise_delivery_errors = true
    # config.action_mailer.delivery_method = :smtp
    # config.action_mailer.smtp_settings = {
    # :address              => "smtp.gmail.com",
    # :port                 => 587,
    # :domain               => '54.183.73.230',
    # :user_name            => 'pintrest.share@gmail.com',
    # :password             => 'pintrest.share789',
    # :authentication       => 'plain',
    # :enable_starttls_auto => true  }

    # config.action_mailer.delivery_method = :smtp
    # config.action_mailer.smtp_settings = {
    # :address              => "smtp.gmail.com",
    # :port                 => 587,
    # :domain               => 'localhost',
    # :user_name            => 'pintrest.share@gmail.com',
    # :password             => 'pintrest.share789',
    # :authentication       => 'plain',
    # :enable_starttls_auto => true  }

    config.action_mailer.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address:              'smtp.gmail.com',
  port:                 587,
  domain:               'example.com',
  user_name:            'pintrest.share@gmail.com',
  password:             'pintrest.share789',
  authentication:       'plain',
  enable_starttls_auto: true  }
    
  end
end