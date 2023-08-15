class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.date :workdate
      t.integer :shift_length_hours
      t.integer :user_id

      t.timestamps
    end
  end
end
