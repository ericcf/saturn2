class CreateRotationSchedules < ActiveRecord::Migration
  def change
    create_table :rotation_schedules do |t|
      t.date :start_date,      null: false
      t.boolean :is_published, null: false, default: false
      t.date :end_date,        null: false

      t.timestamps
    end

    add_index :rotation_schedules, :start_date, unique: true
  end
end
