namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    Subject.create!(:name => "Maths", :description => "Mathematics")
    Subject.create!(:name => "Science", :description => "Science")
    Subject.create!(:name => "English", :description => "English")
    Subject.create!(:name => "Algebra", :description => "Algebra", :parent_id => 1)
    Subject.create!(:name => "Chem", :description => "Chemistry", :parent_id => 2)
    Subject.create!(:name => "Lit", :description => "Literature", :parent_id => 3)
    admin = User.create!(:type => 1,
                 :email => "user@example.com",
                 :password => "foobar",
                 :password_confirmation => "foobar",
                 :first_name => "Test",
                 :last_name => "Admin",
                 :username => "testadmin")
    admin.toggle!(:admin)
    99.times do |n|
      type       = 1 + rand(2)
      first_name = Faker::Name.first_name
      last_name  = Faker::Name.last_name
      name       = [first_name, last_name].join
      email      = "example-#{n+1}@example.com"
      password   = "password"
      subject    = 4 + rand(3)
      User.create!(:type => type,
                   :email => email,
                   :password => password,
                   :password_confirmation => password,
                   :first_name => first_name,
                   :last_name => last_name,
                   :username => Faker::Internet.user_name(name))
      User.find(n+1).subject_ids = [subject]
    end  
  end 
end