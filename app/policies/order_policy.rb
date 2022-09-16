# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  attr_reader :user, :order

  def initialize(user, order)
    super(user)
    @order = order
  end

  permit [:admin], to: %i[update]
  permit [:purchaser], to: %i[create]
  permit %i[purchaser admin], to: %i[index]
  permit %i[purchaser admin], to: %i[show], when: :authorized_user?

  def authorized_user?
    @user.admin? || @order.user == @user
  end
end
