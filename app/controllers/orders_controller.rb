# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_order, only: [:checkout]
  append_before_action :authorize_class, only: %i[index]
  append_before_action :authorize_instance, except: %i[index]

  def index
    @orders = current_user.admin? ? Order.all : Order.of(current_user)
  end

  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
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
    else
      set_flash(:alert, 'Could not place the order!')
    end
    @current_cart.delete
    redirect_to root_path
  end

  private

  def authorize_class
    authorize Order
  end

  def authorize_instance
    authorize(@order || @cart, policy_class: OrderPolicy)
  end


  def initialize_order
    @order = Order.new(user: current_user, restaurant: @current_cart.items.first.restaurant)
    @order.line_items << @current_cart.line_items
  end
end
