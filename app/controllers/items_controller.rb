# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :set_restaurant, only: %i[new create]
  before_action :set_item, only: %i[show edit update destroy]
  after_action :verify_authorized

  def index
    @items = Item.not_retired
    authorize(@items)
  end

  def new
    @item = @restaurant.items.new
    authorize(@item)
    @item.categories.build
  end

  def show; end

  def create
    @item = @restaurant.items.new(item_params)
    authorize(@item)
    @item.save ? redirect_to(@item) : render(:new)
  end

  def edit
    @item.categories.build
  end

  def update
    @item.update(item_params) ? redirect_back(fallback_location: :root) : render(:edit)
  end

  def destroy
    @item.destroy
    redirect_to @item.restaurant
  end

  private

  def set_item
    @item = Item.find(params[:id] || params[:item_id])
    authorize(@item)
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def item_params
    params.require(:item).permit(:title, :description, :price, :photo, :status, category_ids: [])
  end
end
