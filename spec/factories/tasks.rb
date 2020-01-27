FactoryBot.define do
  factory :task do
    title { 'テストを書く' }
    content { 'RSpec & Capybara & FactoryBotを準備する' }
    deadline { Time.current }
    status { :finished }
    priority { :high }
  end
end
