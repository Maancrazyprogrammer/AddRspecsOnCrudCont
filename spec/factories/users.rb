FactoryBot.define do
  factory :user do
    username { "MyString" }
    bio { "hello world" }
    email {"nouman@gmail.com"}
    password {"nouman123"}
    role { %w[admin student].sample }
  end
end
