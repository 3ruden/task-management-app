User.create!(name: ENV['ADMIN_NAME'],
            email: ENV['EMAIL'],
            password: ENV['LOGIN_PASSWORD'],
            password_confirmation: ENV['LOGIN_PASSWORD'],
            admin: true)

4.times do |n|
  Label.create!(name: Faker::Lorem.word)
end

99.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.unique.email
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end

1000.times do |n|
  title = Faker::Lorem.word
  content = Faker::Lorem.sentence
  deadline = Faker::Time.between(from: Time.current.next_week, to: Time.current.next_month)
  status = rand(3)
  priority = rand(3)
  user_id = rand(1..100)
  label_ids = [ rand(1..4) ]
  Task.create!(title: title,
              content: content,
              deadline: deadline,
              status: status,
              priority: priority,
              user_id: user_id,
              label_ids: label_ids)
end
