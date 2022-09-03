# frozen_string_literal: true

class OrdersController < ApplicationController
  include CartConcern

  before_action :authenticate_user!, only: %i[checkout]
  before_action :set_associated_values, only: %i[add_item add_line_item remove_item remove_line_item]
  before_action :set_cart, only: %i[new checkout]
  before_action :set_order, only: %i[show]

  def index
    @orders = Order.where.not(status: :not_placed)
  end

  def show; end

  def update_status
    @order = Order.find(params[:order_id])
    @order.status = params[:order_status]
    if @order.save
      flash[:notice] = translate(:status_updated)
    else
      flash[:alert] = translate(:status_not_updated)
    end
    redirect_to :orders
  end

  def add_line_item
    if @cart
      go_back = false
      different_restaurant? && go_back = true
      if line_item_present?
        go_back = true
        flash[:alert] = translate(:item_in_cart)
      end
      respond_to_js_html and return if go_back
    else
      @cart = Order.new(restaurant: @restaurant, status: :not_placed)
    end
    flash[:notice] = translate(:added_to_cart)
    @cart.order_line_items.new(
      item: @item,
      quantity_ordered: 1,
      sub_total: @item.price
    )
    respond_to_js_html
  end

  def remove_line_item
    if @cart
      unless line_item_present?
        flash[:alert] = translate(:not_in_cart)
        respond_to_js_html and return
      end
      @cart.order_line_items = @cart.order_line_items.reject do |order_line_item|
        order_line_item.item == @item
      end
    else
      flash[:alert] = translate(:already_empty)
    end
    respond_to_js_html
  end

  def add_item
    if @cart
      flash[:alert] = translate(:not_in_cart) unless increase_item_quantity
    else
      flash[:alert] = translate(:not_in_cart)
    end
    respond_to_js_html
  end

  def remove_item
    if @cart
      flash[:alert] = translate(:not_in_cart) unless decrease_item_quantity
    else
      flash[:alert] = translate(:already_empty)
    end
    respond_to_js_html
  end

  def set_associated_values
    @item = Item.find(params[:item_id])
    set_cart
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def set_cart
    @cart =
      if user_signed_in?
        Order.not_placed.find_by(user: current_user)
      else
        session_cart
      end
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def new; end

  def checkout
    @cart.user = current_user
    @cart.status = :ordered
    @cart.submitted_at = Time.current
    if @cart.save
      reset_session_cart
      flash[:notice] = translate(:order_placed)
      redirect_to :orders
    else
      flash[:alert] = translate(:order_not_placed)
      render :new
    end
  end
end
