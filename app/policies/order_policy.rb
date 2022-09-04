# frozen_string_literal: true

class OrderPolicy < ApplicationPolicy
  attr_reader :user, :order

  def initialize(user, order)
    super(user)
    @order = order
  end

  permit [:admin], to: %i[update_status]
  forbid [:admin], to: %i[new add_item add_line_item remove_item remove_line_item]
  permit [:purchaser], to: %i[checkout]
  permit %i[purchaser admin], to: %i[index]
  permit %i[purchaser admin], to: %i[show], when: :placed_by_user

  def placed_by_user
    @user.admin? || @order.user == @user
  end
end
