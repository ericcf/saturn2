class CreateScheduleRotations < ActiveRecord::Migration
  def up
    create_table :schedule_rotations do |t|
      t.integer :schedule_id, null: false
      t.integer :rotation_id, null: false
    end

    add_index :schedule_rotations, [:schedule_id, :rotation_id], unique: true
    execute "ALTER TABLE schedule_rotations ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules (id)"
    execute "ALTER TABLE schedule_rotations ADD CONSTRAINT rotation_fk FOREIGN KEY (rotation_id) REFERENCES rotations (id)"
  end

  def down
    remove_index :schedule_rotations, [:schedule_id, :rotation_id]
    execute "ALTER TABLE schedule_rotations DROP CONSTRAINT schedule_fk"

    drop_table :schedule_rotations
  end
end
