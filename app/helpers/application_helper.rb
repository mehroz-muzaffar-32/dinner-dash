# frozen_string_literal: true

module ApplicationHelper
  def update_status_link(status, order)
    [order, { status: status }]
  end

  def add_quantity_link(line_item)
    user_signed_in? ? line_item_add_path(line_item) : add_quantity_path(line_item.item)
  end

  def reduce_quantity_link(line_item)
    user_signed_in? ? line_item_reduce_path(line_item) : reduce_quantity_path(line_item.item)
  end

  def remove_from_cart_link(line_item)
    user_signed_in? ? line_item : remove_line_item_path(line_item.item)
  end

  def add_to_cart_link(item)
    user_signed_in? ? item_add_to_cart_path(item) : add_line_item_path(item)
  end

  def all_order_statuses
    Order.statuses.keys
  end
end
