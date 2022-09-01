# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized_error

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[full_name display_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[full_name display_name])
  end

  def record_not_found
    flash[:alert] = I18n.t(:not_found)
    redirect_to :root
  end

  def not_authorized_error
    flash[:alert] = I18n.t(:unauthorized)
    redirect_to :root
  end
end
