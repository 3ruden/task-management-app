require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module TaskManagementApp
  class Application < Rails::Application
    config.load_defaults 5.2

    # タイムゾーンを日本に設定
    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.generators do |g|
      # assets helper jbuilderが作成されないよう設定
      g.assets false
      g.helper false
      g.jbuilder false

      # .rspecの生成ファイルを制限
      g.test_framework :rspec,
                   model_specs: true,
                   view_specs: false,
                   helper_specs: false,
                   routing_specs: false,
                   controller_specs: false,
                   request_specs: false
    end
  end
end
