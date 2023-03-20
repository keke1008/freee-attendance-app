class CreateShifts < ActiveRecord::Migration[7.0]
  def change
    create_table :shifts do |t|
      t.references :employee, null: false, foreign_key: true, index: true
      t.datetime :begin_at, null: false
      t.datetime :end_at, null: false

      t.timestamps
    end
  end
end
