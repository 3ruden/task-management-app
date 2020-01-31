require 'rails_helper'

def visit_with_http_auth(path)
  username = ENV['BASIC_AUTH_NAME']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'ユーザー管理機能', type: :system do
  let(:user1){ FactoryBot.create(:user) }
  let(:user2){ FactoryBot.create(:second_user)}

  describe '新規登録画面' do
    before do
      visit_with_http_auth new_user_path
    end

    context '新規登録した場合' do
      it 'マイページ画面に移動する' do
        fill_in 'user_name', with: 'testman'
        fill_in 'user_email', with: 'man@test.com'
        fill_in 'user_password', with: 'testtest'
        fill_in 'user_password_confirmation', with: 'testtest'
        click_on '登録する'
        expect(page).to have_content 'アカウントを作成し、ログインしました'
      end
    end
  end

  describe 'ログイン画面' do
    before do
      visit_with_http_auth root_path
    end

    context '入力した情報とユーザー情報が一致した場合' do
      it 'ログインする' do
        fill_in 'session_email', with: user1.email
        fill_in 'session_password', with: user1.password
        click_on 'ログインする'
        expect(page).to have_content 'ログインしました'
      end
    end
  end
end
