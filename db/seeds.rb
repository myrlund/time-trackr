# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# Delete everything
User.delete_all
Project.delete_all
Registration.delete_all

# Create a user
$user = User.create(email: 'myrlund@gmail.com', password: "passord", password_confirmation: "passord")

# Create some projects for the user
5.times do
  project = Project.create(title: Faker::Company.catch_phrase, description: Faker::Lorem.sentences(2).join("\n\n"), user: $user)
  
  # Make some random time registrations for the project
  (rand(7) + 10).times do
    day = rand(10).days.ago
    hour = rand(24).hours
    duration = (rand(4) + 1).hours
    
    project.registrations.create(description: Faker::Lorem.sentence, start_time: day + hour, duration: duration.seconds, user: $user)
  end
end
