# frozen_string_literal: true

class RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_restaurant, only: %i[show edit update destroy]
  after_action :verify_authorized

  def index
    @restaurants = Restaurant.all
    authorize(@restaurants)
  end

  def new
    @restaurant = Restaurant.new
    authorize(@restaurant)
  end

  def show; end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    authorize(@restaurant)
    if @restaurant.save
      redirect_to @restaurant
    else
      render :new
    end
  end

  def edit; end

  def update
    if @restaurant.update(restaurant_params)
      redirect_to @restaurant
    else
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to :restaurants
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
    authorize(@restaurant)
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end
end
