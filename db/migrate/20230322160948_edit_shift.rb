class EditShift < ActiveRecord::Migration[7.0]
  def up
    add_column :shifts, :date, :date
    change_column :shifts, :date, :date, null: false
    add_column :shifts, :duration_sec, :integer
    change_column :shifts, :duration_sec, :integer, null: false

    change_column :shifts, :begin_at, :time
    change_column :shifts, :end_at, :time
  end

  def down
    remove_column :shifts, :date, :date
    remove_column :shifts, :duration, :integer

    change_column :shifts, :begin_at, :datetime
    change_column :shifts, :end_at, :datetime
  end
end
