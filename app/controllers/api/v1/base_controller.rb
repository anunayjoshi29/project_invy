# app/controllers/api/v1/base_controller.rb
class Api::V1::BaseController < ApplicationController
  before_action :authorize_request

  private

  def authorize_request
    header = request.headers['Authorization']
    token = header.split(' ').last if header

    begin
      decoded_token = JwtTokenService.decode(token)
      @current_user = User.find(decoded_token['user_id']) if decoded_token
    rescue => e
      Rails.logger.error("Authorization error message: #{e}")
      render json: { error: 'Invalid token' }, status: :unauthorized
    end

    unless @current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized && return
    end
  end
end
