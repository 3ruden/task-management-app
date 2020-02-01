require 'rails_helper'

def visit_with_http_auth(path)
  username = ENV['BASIC_AUTH_NAME']
  password = ENV['BASIC_AUTH_PASSWORD']
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'ユーザー機能', type: :system do
  let(:user1){ FactoryBot.create(:user) }
  let(:user2){ FactoryBot.create(:second_user)}

  describe '一般ユーザー機能' do
    describe '新規登録' do
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

    describe 'ログイン' do
      before do
        visit_with_http_auth root_path
        fill_in 'session_email', with: user1.email
        fill_in 'session_password', with: user1.password
        click_on 'ログインする'
      end

      context '入力した情報とユーザー情報が一致した場合' do
        it 'ログインする' do
          expect(page).to have_content 'ログインしました'
        end
      end

      context '一般ユーザーが管理者画面にアクセスした場合' do
        it 'アクセスできない' do
          visit_with_http_auth admin_users_path
          expect(page).not_to have_content'ユーザー一覧'
          expect(page).to have_content 'タスク一覧'
        end
      end
    end
  end

  describe '管理ユーザー機能' do
    let(:admin_user) { FactoryBot.create(:user, name: 'admin_user', admin: true) }
    let(:general_user) { FactoryBot.create(:second_user, name: 'general_user')}

    before do
      FactoryBot.create(:task, title: 'admin_test', user_id: admin_user.id)
      FactoryBot.create(:task, title: 'general_test', user_id: general_user.id)
      visit_with_http_auth root_path
      fill_in 'session_email', with: admin_user.email
      fill_in 'session_password', with: admin_user.password
      click_on 'ログインする'
      visit_with_http_auth admin_users_path
    end

    context '管理ユーザーが管理画面のユーザー一覧にアクセスした場合' do
      it 'アクセスできる' do
        expect(page).to have_content 'ユーザー一覧'
      end
    end

    context 'タスク一覧をクリックした場合' do
      it 'そのユーザーのタスク一覧が表示される' do
        all('.task_index_link')[-1].click
        expect(page).to have_content 'admin_test'
      end
    end

    context 'ユーザーを作成するボタンをクリックしてユーザーを作成した場合' do
      it 'ユーザー一覧に作成したユーザー情報が追加される' do
        click_on 'ユーザーを作成する'
        fill_in 'user_name', with: 'new_user'
        fill_in 'user_email', with: 'new@email.com'
        fill_in 'user_password', with: 'password'
        fill_in 'user_password_confirmation', with: 'password'
        click_on '登録する'
        expect(page).to have_content 'ユーザーを作成しました'
        expect(page).to have_content 'new_user'
      end
    end

    context '編集ボタンをクリックして編集された場合' do
      it 'ユーザー一覧に編集したユーザー情報が更新される' do
        all('.user_edit_link')[0].click
        fill_in 'user_name', with: 'edit_user'
        click_on '更新する'
        expect(page).to have_content 'ユーザーを編集しました'
        expect(page).to have_content 'edit_user'
      end
    end

    context '削除ボタンをクリックした場合' do
      it 'ユーザーが削除される' do
        all('.user_destroy_link')[0].click
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'ユーザーを削除しました'
        expect(page).not_to have_content 'general_user'
      end
    end

    context '管理ユーザーが一人の時に管理ユーザーをを削除しようとした場合' do
      it '管理ユーザーは削除されない' do
        all('.user_destroy_link')[-1].click
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content '管理者がなくなるため、削除できません'
        expect(page).to have_content 'admin_user'
      end
    end

  end
end
