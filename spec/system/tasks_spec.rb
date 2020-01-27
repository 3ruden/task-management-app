require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe 'タスク一覧画面' do
    context 'タスクを作成した場合' do

      it '作成済みのタスクが表示されること' do
        task = FactoryBot.create(:task, title: 'rspectest')
        visit tasks_path
        expect(page).to have_content 'rspectest'
      end
    end
  end

  describe 'タスク登録画面' do
    context '必要項目を入力して、createボタンを押した場合' do
      it 'データが保存されること' do
        visit new_task_path
        # タスク入力フォームにタスク内容が入力する
        fill_in 'Title', with: 'createtest'
        fill_in 'Content', with: 'createtest'
        fill_in 'Deadline', with: Time.current
        choose 'task_status_finished'
        sleep 0.5
        choose 'task_priority_high'
        # タスク作成ボタンをクリック
        click_on 'Create Task'
        # タスクが作成されたか検証する
        expect(page).to have_content 'タスクを作成しました'
      end
    end
  end

  describe 'タスク詳細画面' do
     context '任意のタスク詳細画面に遷移した場合' do
       it '該当タスクの内容が表示されたページに遷移すること' do
         task = FactoryBot.create(:task, title: 'showtest')
         visit task_path(task.id)
         expect(page).to have_content 'showtest'
       end
     end
  end
end
