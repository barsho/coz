namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(firstname: "User",
                 lastname: "Example",
                 email: "example@railstutorial.org",
                 password: "foobar")
    admin.toggle!(:admin)  
    99.times do |n|
      firstname  = Faker::Name.name
      lastname  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(firstname: firstname,
                   lastname: lastname,
                   email: email,
                   password: password)
    end
  end
end