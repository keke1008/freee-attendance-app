class EditAttendance < ActiveRecord::Migration[7.0]
  def up
    add_column :attendances, :date, :date
    change_column :attendances, :date, :date, null: false
    add_column :attendances, :duration_sec, :integer
    change_column :attendances, :duration_sec, :integer, null: false

    change_column :attendances, :begin_at, :time
    change_column :attendances, :end_at, :time
  end

  def down
    remove_column :attendances, :date, :date
    remove_column :attendances, :duration, :integer

    change_column :attendances, :begin_at, :datetime
    change_column :attendances, :end_at, :datetime
  end
end
