# frozen_string_literaL: true

module ItemsHelper
  def can_modify_item?(item)
    policy(item).edit? || policy(item).destroy? || policy(item).update_status?
  end

  def can_add_item_to_cart?(item)
    !current_user&.admin? && item.not_retired?
  end

  def can_remove_from_category?(item)
    policy(item.categories).remove_item?
  end
end
