module Api
  module V1
    # users controller
    class SessionsController < ApplicationController
      def create
        user = User.find_by(email: params[:email])

        if user && user.authenticate(params[:password])
          payload = { user_id: user.id }
          token = JwtTokenService.encode(payload)
          render json: { token: token }
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end
    end
  end
end
