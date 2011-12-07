FactoryGirl.define do
  factory :user do
    sequence(:email){|n| "test-#{n}@test.com" }
    password "foobar"
    password_confirmation {|u| u.password }
  end
  factory :project do
    title "Test"
    user
  end
  factory :registration do
    description "Bla bla bla."
    user
    project
  end
end