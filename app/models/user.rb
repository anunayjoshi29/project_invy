# User model
class User < ApplicationRecord
    has_many :schedules
    enum role: { staff: 0, admin: 1 }
    before_create :set_default_role
  
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Invalid email' }
    has_secure_password
    def self.authenticate(email, password)
      user = find_by(email: email)
      return nil unless user
  
      user.authenticate(password)
    end
  
    def find_accumulated_work_hours(from_date, end_date)
      schedules_within_range = schedules.where(workdate: from_date..end_date)
      total_work_hours = schedules_within_range.sum(&:shift_length_hours)
      total_work_hours
    end
  
    def hours_per_day(from_date, end_date)
      total_work_hours = find_accumulated_work_hours(from_date, end_date)
      number_of_days = (end_date.to_date - from_date.to_date).to_i
      total_work_hours.to_f / number_of_days
    end
  
    def self.hours_per_day_for_all(from_date, end_date)
      user_ids = User.pluck(:id)
  
      ids_and_hours = []
      # Run the function for each user
      user_ids.each do |user_id|
        user = User.find(user_id)
        hours = user.hours_per_day(from_date, end_date)
        ids_and_hours.push([user_id, hours])
      end
      ids_and_hours.sort_by! { |user_id, hours| -hours }
      ids_and_hours.map { |inner_array| inner_array.reject.with_index { |_, index| index == 1 } }.flatten
    end
  
    def get_schedule(from_date, end_date)
      schedules.where(workdate: from_date..end_date)
    end

    private
        def set_default_role
            self.role = 0 if role.nil?
        end
  end
  