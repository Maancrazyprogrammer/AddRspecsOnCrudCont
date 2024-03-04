FactoryBot.define do
  factory :user do
    username { "MyString" }
    bio { "hello world" }
    email {"nouman@gmail.com"}
    password {"nouman123"}
    role { Faker::Base.rand_inclusion(["admin", "student"]) }
  end
end
