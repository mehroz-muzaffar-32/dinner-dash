# frozen_string_literaL: true

module OrdersHelper
  def update_status_link(status, order)
    [order, { status: status }]
  end

  def order_statuses
    Order.statuses.keys
  end
end
