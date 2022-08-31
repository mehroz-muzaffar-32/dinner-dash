# frozen_string_literal: true

class ItemsController < ApplicationController
  before_action :load_current_item, only: %i[show edit update destroy]

  def index
    @items = Item.all
  end

  def new
    @item = Item.new
    @item.restaurant_id = params[:restaurant_id]
  end

  def show; end

  def create
    @item = Item.new(item_permitted_params)
    if @item.save
      redirect_to @item
    else
      render :new
    end
  end

  def edit; end

  def update
    if @item.update(item_permitted_params)
      redirect_to @item
    else
      render 'edit'
    end
  end

  def destroy
    @item.destroy
    redirect_to items_path
  end

  private

  def load_current_item
    @item = Item.find(params[:id])
  rescue StandardError => e
    e.backtrace
    render file: 'public/404'
  end

  def item_permitted_params
    params.require(:item).permit(:title, :description, :price, :restaurant_id)
  end
end
