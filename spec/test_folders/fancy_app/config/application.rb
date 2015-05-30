module FancyApp
  class Application < Rails::Application
    config.i18n.load_path += Dir["#{Rails.root.to_s}"\
                                 "/config/locales/**/*.{rb,yml}"]
    config.i18n.load_path += Dir["#{Rails.root.to_s}"\
                                 "/engines/fancy_app_core/config/"\
                                 "locales/**/*.{rb,yml}"]
  end
end
