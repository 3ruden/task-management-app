FactoryBot.define do
  factory :group_user do
    group { 1 }
    user { 1 }
    owner { false }
  end

  factory :second_group_user, class: GroupUser do
    group { 2 }
    user { 2 }
    owner { true }
  end
end
