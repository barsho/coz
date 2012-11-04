namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(firstname: "User",
                 lastname: "Example",
                 email: "example@railstutorial.org",
                 password: "foobar")
    admin.toggle!(:admin)  
    10.times do |n|
      firstname  = Faker::Name.name
      lastname  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(firstname: firstname,
                   lastname: lastname,
                   email: email,
                   password: password)
    end
    
    users = User.all(limit: 6)
    10.times do
      name = Faker::Lorem.sentence(1)
      users.each { |user| user.projects.create!(name: name) }
    end
    
    projects = Project.all(limit: 10)
    10.times do
      title = Faker::Lorem.sentence(1)
      projects.each { |project| project.conversations.create!(title: title) 
        10.times do
          content = Faker::Lorem.sentence(1)
          project.conversations.each { |conversation| conversation.posts.create!(content: content ) }
        end
      }
    end
  end
end