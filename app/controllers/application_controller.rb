class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    if request.format == 'application/json'
      render json: { error: 'You are not authorized to do that.' }, status: :unauthorized
    else
      flash[:alert] = "You are not authorized to access that page."
      redirect_to root_url
    end
  end

  before_filter :set_current_user

  force_ssl if Rails.env.production? && User.current

  private

  def set_current_user
    User.current = current_user
  end

  def current_user
    if Rails.env.test? && params[:test_user_id]
      session[:user_id] = params[:test_user_id]
    end
    @current_user ||= User.where(id: session[:user_id]).first if session[:user_id]
  end

  def user_signed_in?
    ! current_user.nil?
  end

  helper_method :current_user
  helper_method :user_signed_in?

  def authenticate_user!
    unless user_signed_in?
      session[:request_url] = request.url
      redirect_to new_user_session_url,
        alert: "You must sign in to access that page."
    end
  end
end
