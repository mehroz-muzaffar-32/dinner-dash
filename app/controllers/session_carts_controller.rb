# frozen_string_literal: true

class SessionCartsController < ApplicationController
  before_action :set_item
  before_action :set_cart_items

  def add_line_item
    if cartable?
      @cart_items[@item.id] = 1
      @current_cart[:restaurant_id] = @item.restaurant_id
      set_flash(:notice, 'Item added to cart')
    else
      set_flash(:alert, 'Item not added to cart')
    end
    @cart = hash_to_model
  end

  def remove_line_item
    @cart_items.delete(@item.id)
    @current_cart[:restaurant_id] = nil if @cart_items.empty?
    @cart = hash_to_model
    render :session_cart_update
  end

  def add_quantity
    @cart_items[@item.id] += 1
    @cart = hash_to_model
    render :session_cart_update
  end

  def reduce_quantity
    @cart_items[@item.id] -= 1
    @cart_items.delete(@item.id) if @cart_items[@item.id].zero?
    @current_cart[:restaurant_id] = nil if @cart_items.empty?
    @cart = hash_to_model
    render :session_cart_update
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def set_cart_items
    @cart_items = @current_cart[:cart_items]
  end

  def cartable?
    @current_cart[:restaurant_id].nil? ||
      (@cart_items.exclude?(@item.id) && @current_cart[:restaurant_id] == @item.restaurant_id)
  end
end
