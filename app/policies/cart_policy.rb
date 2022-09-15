# frozen_string_literal: true

class CartPolicy < ApplicationPolicy
  attr_reader :user, :cart

  def initialize(user, cart)
    super(user)
    @cart = cart
  end

  forbid [:admin], to: %i[show destroy], when: :created_by_user?

  def created_by_user?
    @user.nil? || @cart.user == @user
  end
end
