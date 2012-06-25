namespace :db do
  # use this to render data auto for test
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Example User",
                 email: "nguyenngochoang89@gmail.com",
                 password: "foobar",
                 password_confirmation: "foobar")
    admin.toggle!(:admin)
    # admin: true
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end
    # Fake data post
    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5)
      users.each { |user| user.microposts.create!(content: content) }
    end
  end

  # # use it to render admin data
  # desc "Fill database with sample data"
  # task populate: :environment do
  #   admin = User.create!(name: "Example Admin",
  #                        email: "super  @railstutorial.org",
  #                        password: "foobar",
  #                        password_confirmation: "foobar")
  #   admin.toggle!(:admin)
  # end
end