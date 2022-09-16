# frozen_string_literal: true

class CategoriesItemsController < ApplicationController
  before_action :set_category, only: %i[create index]
  before_action :set_categories_item, only: :destroy

  def index
    @categories_items = CategoriesItem.where(category: @category)
  end

  def create
    @category.categories_items.create(categories_item_params)
    redirect_back fallback_location: :root
  end

  def destroy
    @categories_item.destroy
    redirect_back fallback_location: :root
  end

  private

  def set_categories_item
    @categories_item = CategoriesItem.find(params[:id])
  end

  def set_category
    @category = Category.find(params[:category_id])
  end

  def categories_item_params
    params.require(:categories_item).permit(:item_id)
  end
end
