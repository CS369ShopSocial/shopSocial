namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    require 'faker'

    admin = User.create!(name: "Example User",
                 email: "example@railstutorial.org",
                 password: "foobar",
                 password_confirmation: "foobar",
                  admin: true)
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    100.times do |n|
      name = Faker::Company.name
      upc = n
      description = Faker::Lorem.paragraph 
      Article.create!(name: name, upc: upc, description: description)
    end
  end
end
