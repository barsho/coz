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
end