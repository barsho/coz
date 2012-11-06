FactoryGirl.define do
  factory :user do
    sequence(:firstname)  { |n| "Person #{n}" }
    sequence(:lastname)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    
    factory :admin do
      admin true
    end
  end
  
  factory :project do
    name "Lorem ipsum"
    user
  end

  factory :conversation do
    title "Sample convo"
    association :conversationable, factory: :project
  end

  factory :post do
    content "Sample post"
    conversation
    user
  end

end
