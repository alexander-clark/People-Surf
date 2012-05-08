namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    admin = User.create!(:email => "user@example.com",
                 :password => "foobar",
                 :password_confirmation => "foobar",
                 :first_name => "Test",
                 :last_name => "Admin",
                 :username => "testadmin")
    admin.toggle!(:admin)
    99.times do |n|
      first_name = Faker::Name.first_name
      last_name  = Faker::Name.last_name
      name       = [first_name, last_name].join
      email      = "example-#{n+1}@example.com"
      password   = "password"
      User.create!(:email => email,
                   :password => password,
                   :password_confirmation => password,
                   :first_name => first_name,
                   :last_name => last_name,
                   :username => Faker::Internet.user_name(name))
    end  
  end 
end