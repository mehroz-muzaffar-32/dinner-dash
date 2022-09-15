# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_associated_values, only: %i[add_item remove_item]
  before_action :set_category, only: %i[category_items edit destroy update]
  before_action :authorize_class, only: %i[new create]
  before_action :authorize_instance, only: %i[add_item remove_item]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to :categories
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to :categories
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    redirect_back fallback_location: :root
  end

  def add_item
    begin
      @category.items << @item
    rescue StandardError
      set_flash(:alert, 'Item already in this category!')
    end
    redirect_back fallback_location: :root
  end

  def remove_item
    @category.items.destroy(@item)
    redirect_back fallback_location: :root
  end

  def category_items
    @items = Item.eager_load(:categories).where(categories: { id: params[:category_id] })
  end

  private

  def authorize_class
    authorize Category
  end

  def authorize_instance
    authorize(@category)
  end

  def set_category
    @category = Category.find(params[:category_id] || params[:id])
  end

  def set_associated_values
    @item = Item.find(params[:item_id] || params[:category][:item_ids])
    set_category
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
