# frozen_string_literal: true

module CartsHelper
  def add_quantity_link(line_item)
    user_signed_in? ? line_item_add_quantity_path(line_item) : add_quantity_path(line_item.item)
  end

  def reduce_quantity_link(line_item)
    user_signed_in? ? line_item_reduce_quantity_path(line_item) : reduce_quantity_path(line_item.item)
  end

  def remove_from_cart_link(line_item)
    user_signed_in? ? line_item : remove_line_item_path(line_item.item)
  end

  def add_to_cart_link(item)
    user_signed_in? ? item_line_items_path(item) : add_line_item_path(item)
  end

  def can_update_quantity?(line_item)
    !user_signed_in? || policy(line_item).update_quantity?
  end
end
