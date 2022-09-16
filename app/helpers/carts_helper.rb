# frozen_string_literal: true

module CartsHelper

  def update_quantity_link(line_item, quantity_ordered)
    if user_signed_in?
      [line_item, { quantity_ordered: quantity_ordered }]
    else
      update_quantity_path(line_item.item, quantity_ordered: quantity_ordered)
    end
  end

  def remove_from_cart_link(line_item)
    user_signed_in? ? line_item : remove_line_item_path(line_item.item)
  end

  def add_to_cart_link(item)
    user_signed_in? ? item_line_items_path(item) : add_line_item_path(item)
  end

  def can_update_quantity?(line_item)
    !user_signed_in? || policy(line_item).update?
  end
end
