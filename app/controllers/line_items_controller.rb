# frozen_string_literal: true

class LineItemsController < ApplicationController
  before_action :set_item, only: :create
  before_action :set_line_item, only: %i[destroy update]

  def create
    if cartable?
      line_item = @item.line_items.new(container: @current_cart)
      @current_cart.update(restaurant: @item.restaurant)
      authorize line_item
      line_item.save ? set_flash(:notice, 'Item added to cart') : set_flash(:alert, 'Item not added to cart')
    else
      set_flash(:alert, 'Item not added to cart')
    end
  end

  def update
    @line_item.update(quantity_ordered: params[:quantity_ordered])
    render :cart_update
  end

  def destroy
    @line_item.destroy
    render :cart_update
  end

  private

  def set_item
    @item = Item.find(params[:item_id])
  end

  def set_line_item
    @line_item = LineItem.find(params[:id] || params[:line_item_id])
    authorize @line_item
  end

  def cartable?
    cart_items = @current_cart.items
    @current_cart.line_items.empty? ||
      cart_items.exclude?(@item) && @current_cart.restaurant == @item.restaurant && @item.not_retired?
  end
end
