module Api
  module V1
    # users controller
    class UsersController < Api::V1::BaseController
      before_action :authorize_request, except: :create
      before_action :set_user, only: %i[update destroy promote]

      def create
        @user = User.new(user_params)
        if @user.save
          render json: { id: @user.id, message: 'User created successfully' }, status: :created
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize! :manage, @user
        if @user.update(user_params)
          render json: @user
        else
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :manage, @user
        @user.schedules.clear # delete all related schedules
        @user.destroy
        render json: { message: 'User deleted' }, status: :ok
      end

      def promote
        authorize! :manage, @user

        if @user.staff?
          @user.update(role: 'admin')
          render json: { message: 'User has been promoted to admin.' }, status: :ok
        else
          render json: { error: 'User cannot be promoted to admin.' }, status: :unprocessable_entity
        end
      end

      private

      def set_user
        unless params.keys.include?('id')
          render json: { error: 'id is required' }, status: :unprocessable_entity
          return
        end
        begin
          @user = User.find(params[:id])
        rescue => e
          Rails.logger.error("Authorization error message: #{e}")
          render json: { error: 'User not found' }, status: :not_found
        end
      end

      def user_params
        params.require(:user).permit(:email, :password, :role, :name)
      end
    end
  end
end
