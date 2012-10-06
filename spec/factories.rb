FactoryGirl.define do
  factory :user do
    firstname     "Michael"
    lastname     "Hartl"
    email    "michael@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end