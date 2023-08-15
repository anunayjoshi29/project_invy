module Api
  module V1
    # schedules controller
    class SchedulesController < Api::V1::BaseController
      before_action :set_schedule, only: %i[update destroy]
      before_action :date_validate, only: %i[order_by_accumulated_hours get_schedule]

      def index
        @schedules = Schedule.all
        render json: @schedules
      end

      def show
        @user = User.find(params[:user_id])
        @schedule = @user.schedules

        if @schedule
          render json: @schedule
        else
          render json: { error: 'Schedule not found' }, status: :not_found
        end
      end

      def create
        authorize! :manage, @user
        @schedule = Schedule.new(schedule_params)
        if @schedule.save
          render json: @schedule, status: :created
        else
          render json: { errors: @schedule.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        authorize! :manage, @user
        if @schedule.update(schedule_params)
          render json: @schedule
        else
          render json: { errors: @schedule.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        authorize! :manage, @user
        @schedule.destroy
        render json: { message: 'Schedule deleted' }, status: :ok
      end

      def work_hours_by_period
        authorize! :manage, @user
        user = @current_user
        coworkers = User.where.not(id: user.id)
        schedules = Schedule.where(user: coworkers)
        render json: schedules
      end

      def coworker_schedule
        user = User.find(params[:user_id])
        schedule = user.schedules # Assuming a one-to-one relationship between User and Schedule
        if schedule
          render json: schedule
        else
          render json: { error: 'Schedule not found for the user' }, status: :not_found
        end
      end

      def order_by_accumulated_hours
        authorize! :manage, @user
        begin
          user_list = User.hours_per_day_for_all(@start_date, @end_date)
          render json: user_list
        rescue => e
          Rails.logger.error("Error in accumulating hours: #{e}")
          render json: { error: 'Internal Server Error' }, status: :internal_server_error
        end
      end

      def get_schedule
        begin
          unless params.keys.include? 'user_id'
            render json: { error: 'User id not present' }, status: :bad_request
            return
          end
          render json: User.find(params[:user_id]).get_schedule(@start_date, @end_date)
        rescue => e
          Rails.logger.error("Error in getting schedule: #{e}")
          render json: { error: 'Invalid request' }, status: :bad_request
        end
      end

      private

      def set_schedule
        begin
          @schedule = Schedule.find(params[:id])
        rescue => e
          Rails.logger.error("Unable to set schedule: #{e}")
          render json: { error: 'Schedule not found' }, status: :not_found
        end
      end

      def schedule_params
        params.require(:schedule).permit(:workdate, :user_id, :shift_length_hours)
      end

      def date_validate
        result = params.keys.include?('start_date') && params.keys.include?('end_date')
        unless result
          render json: { error: 'start_date and end_date not found' }, status: :not_found
          return
        end
        begin
          @start_date = params[:start_date].to_date
          @end_date = params[:end_date].to_date
          if (@end_date - @start_date).to_i > 365
            Rails.logger.error('Difference more than 1 year')
            render json: { error: 'Difference more than 1 year' }, status: :bad_request
            return
          end
        rescue => e
          Rails.logger.error("Invalid date: #{e}")
          render json: { error: 'Invalid date format' }, status: :bad_request
        end
      end
    end
  end
end
