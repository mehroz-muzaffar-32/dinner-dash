# frozen_string_literal: true

class ItemPolicy < ApplicationPolicy
  attr_reader :user, :item

  def initialize(user, item)
    super(user)
    @item = item
  end

  permit [:admin], to: %i[new create edit update destroy]
end
