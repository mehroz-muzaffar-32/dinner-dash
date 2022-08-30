# frozen_string_literal: true

class RestaurantsController < ApplicationController
  before_action :run_authorization, except: %i[index show]
  after_action :verify_authorized, except: %i[index show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = Restaurant.new
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  rescue StandardError => e
    e.backtrace
    render plain: "Couldn't Find the restaurant you are looking for"
  end

  def create
    @restaurant = Restaurant.new(restaurant_permitted_params)
    if @restaurant.save
      redirect_to @restaurant
    else
      render :new
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  rescue StandardError => e
    e.backtrace
    render plain: "Couldn't Find the restaurant you are looking for"
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.update(restaurant_permitted_params)
      redirect_to @restaurant
    else
      render 'edit'
    end
  rescue StandardError => e
    e.backtrace
    render plain: "Couldn't Find the restaurant you are looking for"
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    @restaurant.destroy
    redirect_to restaurants_path
  rescue StandardError => e
    e.backtrace
    render plain: "Couldn't Find the restaurant you are looking for"
  end

  private

  def run_authorization
    authorize Restaurant
  rescue StandardError => e
    e.backtrace
    render plain: 'You are not authorized to this page/path'
  end

  def restaurant_permitted_params
    params.require(:restaurant).permit(:name)
  end
end
