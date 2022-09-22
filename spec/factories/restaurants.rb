# frozen_string_literal: true

FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.unique.name }

    trait :blank_name do
      name { '' }
    end
  end
end
