# frozen_string_literal: true

class LineItemPolicy < ApplicationPolicy
  attr_reader :user, :line_item

  def initialize(user, line_item)
    super(user)
    @line_item = line_item
  end

  permit [:purchaser], to: %i[create destroy add_quantity reduce_quantity], when: :added_by_user?

  def added_by_user?
    @line_item.container.user == @user
  end
end
