# frozen_string_literal: true

class RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_restaurant, only: %i[show edit update destroy]
  before_action :authorize_class, only: %i[new]
  before_action :authorize_instance, only: %i[edit update destroy]
  after_action :verify_authorized, except: %i[index show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def show; end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    authorize @restaurant
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
  end

  def authorize_class
    authorize Restaurant
  end

  def authorize_instance
    authorize @restaurant
  end

  def restaurant_params
    params.require(:restaurant).permit(:name)
  end
end
