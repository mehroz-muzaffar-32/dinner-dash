# frozen_string_literal: true

class RestaurantPolicy
  attr_reader :user, :restaurant

  def initialize(user, restaurant)
    @user = user
    @restaurant = restaurant
  end

  def new?
    @user&.admin?
  end

  def create?
    @user&.admin?
  end

  def edit?
    @user&.admin?
  end

  def update?
    @user&.admin?
  end

  def destroy?
    @user&.admin?
  end
end
