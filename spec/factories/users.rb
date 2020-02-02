FactoryBot.define do
  factory :user do
    name { "テストマン" }
    email { "test@man.com" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
  end

  factory :second_user, class: User do
    name { "hogehoge" }
    email { "hoge@hoge.jp" }
    password { "password" }
    password_confirmation { "password" }
    admin { false }
  end

end
