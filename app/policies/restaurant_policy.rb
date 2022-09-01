# frozen_string_literal: true

class RestaurantPolicy < ApplicationPolicy
  attr_reader :user, :restaurant

  def initialize(user, restaurant)
    super(user)
    @restaurant = restaurant
  end

  permit [:admin], to: %i[new create edit update destroy]
end
