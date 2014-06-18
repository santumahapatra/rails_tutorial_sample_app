FactoryGirl.define do
  factory :user do
    name     "Michael Hartl"
    email    "michael@example.com"
    password "foobarbaz"
    password_confirmation "foobarbaz"
  end
end