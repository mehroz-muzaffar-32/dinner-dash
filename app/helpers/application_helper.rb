# frozen_string_literal: true

module ApplicationHelper
  def status_link_to(display_text, status, order)
    link_to display_text, [order, { status: status }], method: :patch
  end

  def add_quantity_link(display_text, line_item)
    if user_signed_in?
      link_to display_text, line_item_add_path(line_item), method: :post, remote: true
    else
      link_to display_text, add_quantity_path(line_item.item), method: :post, remote: true
    end
  end

  def reduce_quantity_link(display_text, line_item)
    if user_signed_in?
      link_to display_text, line_item_reduce_path(line_item), method: :post, remote: true
    else
      link_to display_text, reduce_quantity_path(line_item.item), method: :post, remote: true
    end
  end

  def remove_from_cart_link(display_text, line_item)
    if user_signed_in?
      link_to display_text, line_item, method: :delete, remote: true
    else
      link_to display_text, remove_line_item_path(line_item.item), method: :post, remote: true
    end
  end

  def add_to_cart_link(display_text, item)
    if user_signed_in?
      link_to display_text, item_add_to_cart_path(item), method: :post, remote: true
    else
      link_to display_text, add_line_item_path(item), method: :post, remote: true
    end
  end
end
