require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :model do

  describe 'バリデーションテスト' do
    it 'titleが空ならバリデーションが通らない' do
      task = FactoryBot.build(:task, title: '')
      expect(task).not_to be_valid
    end

    it 'contentが空ならバリデーションが通らない' do
      task = FactoryBot.build(:task, content: '')
      expect(task).not_to be_valid
    end

    it 'titleとcontentに内容が記載されていればバリデーションが通る' do
      task = FactoryBot.build(:task, title: '成功テスト', content: '成功テスト')
      expect(task).to be_valid
    end
  end

  describe 'scopeテスト' do
    let(:task) { FactoryBot.create(:task)}

    it 'get_search_titleが正しく動作している' do
      expect(Task.get_search_title("テストを書く")).to include(task)
    end

    it 'get_search_statusが正しく動作している' do
      expect(Task.get_search_status("finished")).to include(task)
    end
  end
end
