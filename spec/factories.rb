# By using the symbol ':user', we get Factory Girl to simulate the User model.
FactoryGirl.define do
  factory :user do
    type                  "1"
    email                 "test@example.com"
    password              "foobar"
    password_confirmation "foobar"
    first_name            "Example"
    last_name             "User"
    username              "example.user"
  end
end

FactoryGirl.define do
  sequence :email do |n|
    "person-#{n}@example.com"
  end
end

FactoryGirl.define do
  sequence :username do |n|
    "person-#{n}"
  end
end

FactoryGirl.define do
  factory :subject do
    name        "Maths"
    description "Mathematics"
  end
end