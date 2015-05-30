FactoryGirl.define do
  factory :user, class: OrigEngine::User do
    sequence(:email) { |n| "user_#{n}@example.com" }
    sequence(:name)  { |n| "Firstname_#{n} Lastname_#{n}" }
  end
end
