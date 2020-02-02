FactoryBot.define do
  factory :task do
    title { 'テストを書く' }
    content { 'RSpec & Capybara & FactoryBotを準備する' }
    deadline { Time.current }
    status { :finished }
    priority { :high }
  end

  factory :second_task, class: Task do
    title { 'test2' }
    content { 'RSpec & Capybara & FactoryBotを準備するその２' }
    deadline { Time.current.next_month }
    status { :get_started }
    priority { :low }
  end
end
