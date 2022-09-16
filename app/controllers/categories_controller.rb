# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, except: %i[index new create]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
    authorize(@category)
  end

  def create
    @category = Category.new(category_params)
    authorize(@category)
    @category.save ? redirect_to(:categories) : render(:new)
  end

  def edit; end

  def update
    @category.update(category_params) ? redirect_to(:categories) : render(:edit)
  end

  def destroy
    @category.destroy
    redirect_back fallback_location: :root
  end

  private

  def set_category
    @category = Category.find(params[:category_id] || params[:id])
    authorize(@category)
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
