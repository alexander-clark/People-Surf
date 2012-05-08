# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.email                 "test@example.com"
  user.password              "foobar"
  user.password_confirmation "foobar"
  user.first_name            "Example"
  user.last_name             "User"
  user.username              "example.user"
end

Factory.sequence :email do |n|
  "person-#{n}@example.com"
end

Factory.sequence :username do |n|
  "person-#{n}"
end