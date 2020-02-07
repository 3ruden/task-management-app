module Utilities
  def visit_with_http_auth(path)
    username = ENV["BASIC_AUTH_NAME"]
    password = ENV["BASIC_AUTH_PASSWORD"]
    visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
  end
end
