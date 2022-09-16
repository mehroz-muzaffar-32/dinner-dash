# frozen_string_literal: true

class SessionLineItemsController < ApplicationController
  before_action :set_item
  before_action :set_cart_items

  def create
    if cartable?
      @cart_items[@item.id] = 1
      @current_cart[:restaurant_id] = @item.restaurant_id
      set_flash(:notice, 'Item added to cart')
    else
      set_flash(:alert, 'Item not added to cart')
    end
    @cart = session_line_items
  end

  def update
    @cart_items[@item.id] = params[:quantity_ordered].to_i
    @cart_items.delete(@item.id) if @cart_items[@item.id].zero?
    @cart = session_line_items
  end

  def destroy
    @cart_items.delete(@item.id)
    @cart = session_line_items
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def set_cart_items
    @cart_items = @current_cart[:cart_items]
  end

  def cartable?
    @cart_items.empty? ||
      (@cart_items.exclude?(@item.id) &&
        @current_cart[:restaurant_id] == @item.restaurant_id &&
        @item.not_retired?)
  end
end
