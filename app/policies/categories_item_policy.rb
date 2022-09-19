# frozen_string_literal: true

class CategoriesItemPolicy < ApplicationPolicy
  attr_reader :user, :categories_item

  def initialize(user, categories_item)
    super(user)
    @categories_item = categories_item
  end

  permit [:admin], to: %i[create destroy]
end
