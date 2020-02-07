require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let(:login_user){ FactoryBot.create(:user) }
  let(:task){ FactoryBot.create(:task, user:login_user)}

  before do
    FactoryBot.create(:label)
    @label_id = Label.find_by(name: '仮ラベル').id
    task.label_ids = [@label_id]
    FactoryBot.create(:second_task, user: login_user)
    visit_with_http_auth root_path
    fill_in 'session_email', with: login_user.email
    fill_in 'session_password', with: login_user.password
    click_on 'ログインする'
  end

  describe 'タスク一覧画面' do
    before do
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
        fill_in 'title_search', with: 'テストを書く'
        click_on '検索する'
        expect(page).to have_content 'テストを書く'
        expect(page).not_to have_content 'test2'
      end
    end

    context 'タスクの状態を検索した場合' do
      it '検索したタスクの状態のみのレコードが表示される' do
        select '完了', from: 'status_search'
        click_on '検索する'
        task_list = all('.task_row')
        expect(task_list[0]).to have_content '完了'
        expect(page).not_to have_content 'test2'
      end
    end

    context 'タスクをラベルで検索した場合' do
      it '検索したラベルがついているタスクのみが表示される' do
        select '仮ラベル', from: 'label_id'
        click_on '検索する'
        expect(page).to have_content 'テストを書く'
        expect(page).not_to have_content 'test2'
      end
    end
  end

  describe 'タスク登録画面' do
    before do
      visit_with_http_auth new_task_path
    end

    context '必要項目を入力して、登録するボタンを押した場合' do
      it 'データが保存されること' do
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

    context 'ラベルのチェックボックスにチェックして登録ボタンを押した時' do
      it 'ラベルも登録されている' do
        fill_in 'タスク名', with: 'labeltest'
        fill_in 'タスク詳細', with: 'labeltest'
        fill_in '終了期限', with: Time.current
        choose 'task_status_finished'
        choose 'task_priority_high'
        check "task_label_ids_#{@label_id}"
        click_on '登録する'
        expect(page).to have_content '仮ラベル'
      end
    end
  end

  describe 'タスク詳細画面' do
    let(:showtask){ FactoryBot.create(:task, title: 'showtest', user: login_user) }

    context '任意のタスク詳細画面に遷移した場合' do
      it '該当タスクの内容が表示されたページに遷移すること' do
        visit task_path(showtask)
        expect(page).to have_content 'showtest'
      end
    end
  end
end
