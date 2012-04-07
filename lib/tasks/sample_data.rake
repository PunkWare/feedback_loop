namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "admin",
                 email: "punkware@free.fr",
                 password: "Thomas",
                 password_confirmation: "Thomas")
    admin.toggle!(:admin)
    
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@free.fr"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    users = User.all(limit: 6)
      30.times do
      title             = Faker::Lorem.sentence(4)
      users.each { |user| user.surveys.create!( title: title ) }
    end
  end
end