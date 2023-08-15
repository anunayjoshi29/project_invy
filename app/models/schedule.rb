# schedule mode
class Schedule < ApplicationRecord
    belongs_to :user
    validates :workdate, :user_id, :shift_length_hours, presence: true
    validates :workdate, format: { with: /\A\d{4}-\d{2}-\d{2}\z/, message: 'should be in the format yyyy-mm-dd' }
    validates :shift_length_hours, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 24}
    validate :unique_schedule_per_user_and_workdate, on: :create
  
    scope :ordered_by_hours, -> { order('shift_length DESC') }
  
    private
  
    def unique_schedule_per_user_and_workdate
      if Schedule.where(user_id: user_id, workdate: workdate).exists?
        errors.add(:base, 'A schedule already exists for this user and work date')
      end
    end
  end
  