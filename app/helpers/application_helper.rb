# frozen_string_literal: true

module ApplicationHelper
  def status_link_to(display_text, status, order)
    link_to display_text, order_update_status_path(order_id: order.id, order_status: status)
  end
end
