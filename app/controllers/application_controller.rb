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
    msg = 'The resource you are looking for does not exist'
    redirect_to root_path, notice: msg
  end

  def not_authorized_error
    msg = 'You are not authorized to this page/path'
    redirect_to root_path, notice: msg
  end
end
