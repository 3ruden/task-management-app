FactoryBot.define do
  factory :group do
    name { "TestGroup" }
    content { "TestGroup" }
  end

  factory :second_group, class: Group do
    name { "TestGroup" }
    content { "TestGroup" }
  end
end
