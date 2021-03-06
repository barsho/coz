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
    3.times do
      name = Faker::Lorem.sentence(1)
      users.each { |user| user.create_conversation(title: user.firstname) }
      users.each { |user| user.projects.create!(name: name) }
    end
    
    projects = Project.all(limit: 10)
    3.times do
      title = Faker::Lorem.sentence(1)
      projects.each { |project| project.conversations.create!(title: title) 
        5.times do
          content = Faker::Lorem.sentence(1)
          project.conversations.each { |conversation|  
               users.each { |user| user.posts.create!(content: content, conversation: conversation) }
          }
          
        end
      }
    end
    
    
    
  end
end