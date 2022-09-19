# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: %i[show update]

  def index
    @current_status = params[:order_status] || :all
    @orders = (current_user.admin? ? Order.all : Order.of(current_user)).with(@current_status)
    authorize(@orders)
  end

  def show; end

  def update
    if @order.update(status: params[:status])
      set_flash(:notice, 'Order status updated!')
    else
      set_flash(:alert, 'Order status not updated!')
    end
    redirect_back fallback_location: :root
  end

  def create
    @order = Order.new(
      user: current_user,
      restaurant: @current_cart.items.first.restaurant,
      line_items: @current_cart.line_items
    )
    authorize(@order)
    if @order.save
      set_flash(:notice, 'Order placed successfully!')
      @current_cart.delete
    else
      set_flash(:alert, 'Could not place the order!')
    end
    redirect_to root_path
  end

  private

  def set_order
    @order = Order.find(params[:id])
    authorize(@order)
  end
end
