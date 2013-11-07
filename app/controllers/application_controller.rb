class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  rescue_from ActionController::RedirectBackError do |exception|
    redirect_to root_url, :alert => exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    redirect_to root_url, :alert => exception.message
  end

  before_filter :set_current_user

  private

    def set_current_user
      Thread.current[:audited_admin] = current_user
      Thread.current[:ip] = request.try(:ip) 
    end
    
end
