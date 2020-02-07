require 'rails_helper'

RSpec.describe GroupUser, type: :model do
  let(:group) { FactoryBot.create(:group) }
  let(:user) { FactoryBot.create(:user) }
  let(:second_group) { FactoryBot.create(:second_group) }
  let(:second_user) { FactoryBot.create(:second_user) }

  before do
    FactoryBot.create(:group_user, group: group, user: user, owner: true)
  end

  describe 'バリデーションテスト' do
    let(:not_unique_group_user) {
      FactoryBot.build(:group_user, group: group, user: user)
 }
    let(:owner_group_user) {
      FactoryBot.build(:second_group_user, group: group, user: second_user)
    }

    it 'group_idとuser_idは一意である' do
      expect(not_unique_group_user).not_to be_valid
    end

    it '１つのグループにグループ作成者は一人である' do
      expect(owner_group_user).not_to be_valid
    end

  end
end
