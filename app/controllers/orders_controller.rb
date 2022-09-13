# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_order, only: [:checkout]
  before_action :set_order, only: %i[show update]
  before_action :authorize_class, only: %i[index]
  before_action :authorize_instance, except: %i[index]

  def index
    @current_status = params[:order_status] || :all
    @orders = (current_user.admin? ? Order.all : Order.of(current_user)).with(@current_status)
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

  def checkout
    if @order.save
      set_flash(:notice, 'Order placed successfully!')
      @current_cart.delete
    else
      set_flash(:alert, 'Could not place the order!')
    end
    redirect_to root_path
  end

  private

  def authorize_class
    authorize Order
  end

  def authorize_instance
    authorize(@order)
  end

  def initialize_order
    @order = Order.new(user: current_user, restaurant: @current_cart.items.first.restaurant)
    @order.line_items << @current_cart.line_items
  end

  def set_order
    @order = Order.find(params[:id])
  end
end
