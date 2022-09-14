# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_cart

  rescue_from StandardError, with: :error_handler

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name display_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[full_name display_name])
  end

  def error_handler(exception)
    flash[:alert] = exception
    redirect_to :root
  end

  def set_current_cart
    if user_signed_in? && current_user.purchaser?
      @current_cart = Cart.find_or_create_by(user: current_user)
      old_cart_items = session_cart[:cart_items]
      sync_cart(old_cart_items) if old_cart_items.any? && @current_cart.line_items.empty?
    else
      @current_cart = session_cart
    end
  end

  def sync_cart
    @current_cart.line_items << old_cart_items.map do |key, value|
      LineItem.new(item_id: key, quantity_ordered: value)
    end
    old_cart_items.clear
  end

  def session_cart
    session[:cart] ||= { restaurant_id: nil, cart_items: {} }
    session[:cart] = session[:cart].with_indifferent_access
    session[:cart][:cart_items].transform_keys!(&:to_i)
    session[:cart]
  end

  def hash_to_model
    cart = Cart.new
    cart.line_items << @current_cart[:cart_items].map do |key, value|
      LineItem.new(item_id: key, quantity_ordered: value)
    end
    cart
  end

  def set_flash(tag, message)
    flash[tag] = message
  end
end
