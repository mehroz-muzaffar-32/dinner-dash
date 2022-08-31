# frozen_string_literal: true

class RestaurantsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :run_authorization, only: %i[new]
  before_action :load_current_restaurant, only: %i[show edit update destroy]
  after_action :verify_authorized, except: %i[index show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def show; end

  def create
    @restaurant = Restaurant.new(restaurant_permitted_params)
    if @restaurant.save
      redirect_to @restaurant
    else
      render :new
    end
  end

  def edit; end

  def update
    if @restaurant.update(restaurant_permitted_params)
      redirect_to @restaurant
    else
      render 'edit'
    end
  end

  def destroy
    @restaurant.destroy
    redirect_to restaurants_path
  end

  private

  def run_authorization
    authorize Restaurant
  end

  def load_current_restaurant
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
  end

  def restaurant_permitted_params
    params.require(:restaurant).permit(:name)
  end
end
