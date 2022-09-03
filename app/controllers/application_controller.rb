# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :configure_permitted_parameters, if: :devise_controller?
  after_action :update_orders_table, only: %i[create], if: :devise_controller?
  after_action :reset_session_cart, only: %i[destroy], if: :devise_controller?

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

  def create_session_cart_from(order)
    session[:cart] = order.as_json
    session[:cart_items] = order.order_line_items.to_a
  end

  def save_session_cart
    order = Order.new(session[:cart])
    order.order_line_items.new(session[:cart_items])
    order.user = current_user
    if order.save
      flash[:notice] = translate(:cart_saved)
    else
      flash[:alert] = translate(:cart_not_saved)
    end
  end

  def update_orders_table
    return unless user_signed_in?

    order = Order.not_placed.find_by(user: current_user)
    if order
      create_session_cart_from(order)
    elsif session[:cart] && session[:cart_items]
      save_session_cart
    end
  end

  def reset_session_cart
    session[:cart] = nil
    session[:cart_items] = nil
  end

  def translate(tag)
    I18n.t(tag)
  end
end
