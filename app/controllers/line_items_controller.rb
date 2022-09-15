# frozen_string_literal: true

class LineItemsController < ApplicationController
  before_action :set_item, only: :create
  before_action :set_line_item, only: %i[add_quantity reduce_quantity destroy]

  def create
    if cartable?
      line_item = @item.line_items.new(container: @current_cart)
      authorize line_item
      if line_item.save
        set_flash(:notice, 'Item added to cart')
      else
        set_flash(:alert, 'Item not added to cart')
      end
    else
      set_flash(:alert, 'Item not added to cart')
    end
  end

  def destroy
    @line_item.destroy
    render :cart_update
  end

  def add_quantity
    @line_item.increment(:quantity_ordered)
    if @line_item.save
      set_flash(:notice, 'Quantity Updated!')
    else
      set_flash(:alert, 'Quantity Not Updated')
    end
    render :cart_update
  end

  def reduce_quantity
    @line_item.decrement(:quantity_ordered)
    if @line_item.quantity_ordered.zero?
      @line_item.destroy
    elsif @line_item.save
      set_flash(:notice, 'Quantity Updated!')
    else
      set_flash(:alert, 'Quantity Not Updated')
    end
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
    @current_cart.items.exclude?(@item) &&
      @current_cart.items.all? { |cart_item| cart_item.restaurant == @item.restaurant } &&
      @item.not_retired?
  end
end
