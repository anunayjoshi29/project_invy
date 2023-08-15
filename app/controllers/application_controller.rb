# application controller
class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session # Disable CSRF protection for API requests
    attr_reader :current_user
  
    rescue_from CanCan::AccessDenied do
      render json: { error: 'Unauthorized to do this task' }, status: :unauthorized
    end
  end
  