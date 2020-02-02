Rails.application.configure do
  config.cache_classes = false

  config.eager_load = false

  config.consider_all_requests_local = true

  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.active_storage.service = :local

  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  config.active_support.deprecation = :log

  config.active_record.migration_error = :page_load

  config.active_record.verbose_query_logs = true

  config.assets.debug = true

  config.assets.quiet = true

  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.after_initialize do
    Bullet.enable = true # Bulletを有効化
    Bullet.alert = true # JavaScriptのポップアップアラートを有効化
    Bullet.bullet_logger = true # Rails.root/log/bullet.logに出力
    Bullet.console = true # ブラウザのconsole.logに出力
    Bullet.rails_logger = true # Railsのログに結果を出力
    Bullet.add_footer = true # ページの左下に結果を表示
  end
end
