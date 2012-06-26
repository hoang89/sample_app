FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}"}
    sequence(:email) {|n| "example#{n}@example.com"} 
    password "foobar"
    password_confirmation "foobar"
    factory :admin do
      admin true
    end
  end
  # make a factory test for micropost
  factory :micropost do
    content "Lorem ipsum"
    user
  end

end