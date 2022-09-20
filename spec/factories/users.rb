# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    full_name { Faker::Name.name }
    display_name { Faker::Internet.username(specifier: 2..32) }
    email { Faker::Internet.unique.email }
    password { 'password' }
  end
end
