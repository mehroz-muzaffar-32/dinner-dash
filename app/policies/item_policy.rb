# frozen_string_literal: true

class ItemPolicy
  attr_reader :user, :item

  def initialize(user, item)
    @user = user
    @item = item
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
