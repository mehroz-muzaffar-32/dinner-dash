# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_item_restaurant, only: %i[new create]
  before_action :set_item, only: %i[show edit update destroy]
  before_action :authorize_class, only: %i[new]
  before_action :authorize_instance, only: %i[edit update destroy]
  after_action :verify_authorized, except: %i[index show]

  def index
    @items = Item.all
    render :popular_items
  end

  def new
    @item = @restaurant.items.new
  end

  def show; end

  def create
    @item = @restaurant.items.new(item_params)
    authorize @item
    if @item.save
      redirect_to @item
    else
      render :new
    end
  end

  def edit; end

  def update
    if @item.update(item_params)
      redirect_to @item
    else
      render 'edit'
    end
  end

  def destroy
    restaurant = @item.restaurant
    @item.destroy
    redirect_to restaurant
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def set_item_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def authorize_class
    authorize Item
  end

  def authorize_instance
    authorize @item
  end

  def item_params
    params.require(:item).permit(:title, :description, :price)
  end
end
