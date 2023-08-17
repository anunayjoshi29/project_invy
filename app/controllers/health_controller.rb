# health check
class HealthController < ApplicationController
  def index
    check
  end

  private

  def check
    ActiveRecord::Base.connection.active?
    render json: { status: good }, status: 200
  rescue StandardError => e
    render json: { status: e }, status: 503
  end

  def good
    'Server is up'
  end
end
