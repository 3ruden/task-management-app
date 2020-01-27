require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe 'タスク一覧画面' do
    before do
      FactoryBot.create(:task, title: 'rspectest')
    end

    context 'タスクを作成した場合' do
      it '作成済みのタスクが表示されること' do
        visit tasks_path
        expect(page).to have_content 'rspectest'
      end
    end

    context '複数のタスクを作成した場合' do
      it 'タスクが作成日時の降順に並んでいること' do
        new_task = FactoryBot.create(:task, title: 'new_task')
        visit tasks_path
        task_list = all('.task_row')
        expect(task_list[0]).to have_content 'new_task'
        expect(task_list[1]).to have_content 'rspectest'
      end
    end
  end

  describe 'タスク登録画面' do
    context '必要項目を入力して、createボタンを押した場合' do
      it 'データが保存されること' do
        visit new_task_path
        # タスク入力フォームにタスク内容が入力する
        fill_in 'タスク名', with: 'createtest'
        fill_in 'タスク詳細', with: 'createtest'
        fill_in '終了期限', with: Time.current
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
