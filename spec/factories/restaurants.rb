# frozen_string_literal: true

FactoryBot.define do
  factory :restaurant do
    name { Faker::Restaurant.unique.name }
  end
end
