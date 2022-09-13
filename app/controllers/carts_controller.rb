# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :set_cart, only: [:show]

  def show; end

  def destroy
    if user_signed_in?
      @current_cart.destroy
    else
      @current_cart[:cart_items].clear
      @current_cart[:restaurant_id] = nil
    end
    redirect_to :root
  end

  private

  def set_cart
    @cart = user_signed_in? ? @current_cart : hash_to_model
  end
end
