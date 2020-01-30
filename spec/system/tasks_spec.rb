require 'rails_helper'

def visit_with_http_auth(path)
  username = ENV["BASIC_AUTH_NAME"]
  password = ENV["BASIC_AUTH_PASSWORD"]
  visit "http://#{username}:#{password}@#{Capybara.current_session.server.host}:#{Capybara.current_session.server.port}#{path}"
end

RSpec.describe 'タスク管理機能', type: :system do
  describe 'タスク一覧画面' do
    before do
      FactoryBot.create(:task)
      FactoryBot.create(:second_task)
      visit_with_http_auth tasks_path
    end

    context 'タスクを作成した場合' do
      it '作成済みのタスクが表示されること' do
        expect(page).to have_content 'テストを書く'
      end
    end

    context '複数のタスクを作成した場合' do
      it 'タスクが作成日時の降順に並んでいること' do
        task_list = all('.task_row')
        expect(task_list[0]).to have_content 'test2'
        expect(task_list[1]).to have_content 'テストを書く'
      end
    end

    context '期限順に並べるボタンをクリックした場合' do
      it 'タスクが終了期限順に並んでいること' do
        click_on '期限順に並べる'
        task_list = all('.task_row')
        expect(task_list[0]).to have_content 'テストを書く'
        expect(task_list[1]).to have_content 'test2'
      end
    end

    context '優先度の高い順に並べるボタンをクリックした場合' do
      it 'タスクが優先度の高い順に並んでいること' do
        click_on '期限順に並べる'
        task_list = all('.task_row')
        expect(task_list[0]).to have_content '高'
        expect(task_list[1]).to have_content '低'
      end
    end

    context 'タスク名を検索した場合' do
      it '検索したタスク名のみのレコードが表示される' do
        fill_in 'task_title_search', with: 'テストを書く'
        click_on '検索する'
        expect(page).to have_content 'テストを書く'
        expect(page).not_to have_content 'test2'
      end
    end

    context 'タスクの状態を検索した場合' do
      it '検索したタスクの状態のみのレコードが表示される' do
        select '完了', from: 'task_status_search'
        click_on '検索する'
        task_list = all('.task_row')
        expect(task_list[0]).to have_content '完了'
        expect(page).not_to have_content 'test2'
      end
    end
  end

  describe 'タスク登録画面' do
    context '必要項目を入力して、createボタンを押した場合' do
      it 'データが保存されること' do
        visit_with_http_auth new_task_path
        # タスク入力フォームにタスク内容が入力する
        fill_in 'タスク名', with: 'createtest'
        fill_in 'タスク詳細', with: 'createtest'
        fill_in '終了期限', with: Time.current.next_year
        choose 'task_status_finished'
        choose 'task_priority_high'
        # タスク作成ボタンをクリック
        click_on '登録する'
        # タスクが作成されたか検証する
        expect(page).to have_content 'タスクを作成しました'
      end
    end
  end

  describe 'タスク詳細画面' do
     let(:showtask){ FactoryBot.create(:task, title: 'showtest') }

     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示されたページに遷移すること' do
         visit task_path(showtask)
         expect(page).to have_content 'showtest'
       end
     end
  end
end
