# frozen_string_literal: true

class CategoryPolicy < ApplicationPolicy
  attr_reader :user, :category

  def initialize(user, category)
    super(user)
    @category = category
  end

  permit [:admin], to: %i[new create edit update destroy add_item remove_item]
end
