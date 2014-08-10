namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    make_microposts
    make_relationships
  end
end

def make_users
  admin = User.create!(name:     "Example User",
                       email:    "example@railstutorial.org",
                       password: "foobar",
                       password_confirmation: "foobar",
                       admin: true)
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_microposts
  users = User.all(limit: 6)
  50.times do
    content = Faker::Lorem.sentence(5)
    users.each { |user| user.microposts.create!(content: content) }
  end
end

def make_relationships
  users = User.all        #users = all users
  user  = users.first     #user = first user
  followed_users = users[2..50]  #followed_users = user#3 - #51
  followers      = users[3..40]  #followers = user#4 - #41
  followed_users.each { |followed| user.follow!(followed) }  #users[2..50].each { |i| user.follow!(i)}. first user followed users#3-#51
  followers.each      { |follower| follower.follow!(user) }   #user#4-#41 follows first user
end