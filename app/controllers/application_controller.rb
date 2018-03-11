class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  http_basic_authenticate_with name: ENV['BASIC_AUTH_USERNAME'], password: ENV['BASIC_AUTH_PASSWORD'] if Rails.env == "production"

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def authenticate_user
    if current_user.nil?
      redirect_to login_path, alert: "ログインしてください"
    end
  end
end
