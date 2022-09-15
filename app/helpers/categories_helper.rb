# frozen_string_literaL: true

module CategoriesHelper
  def can_modify_category?(category)
    policy(category).edit? && policy(category).destroy?
  end

  def can_add_category?(category)
    policy(category).new?
  end
end
