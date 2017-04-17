require_relative "boot"

require "rails/all"
require "action_mailer/railtie"

Bundler.require(*Rails.groups)
require "ransack_predicate_cont_any_word"

module Dummy; end

class Dummy::Application < Rails::Application
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.
end
