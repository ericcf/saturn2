class CreateRotationAssignments < ActiveRecord::Migration
  def up
    create_table :rotation_assignments do |t|
      t.integer :person_id,            null: false
      t.integer :rotation_id,          null: false
      t.date :starts_on,               null: false
      t.date :ends_on,                 null: false
      t.integer :editor_id
      t.boolean :is_deleted,           null: false, default: false
      t.integer :rotation_schedule_id, null: false

      t.timestamps
    end

    add_index :rotation_assignments, :person_id
    add_index :rotation_assignments, :rotation_id
    execute "ALTER TABLE rotation_assignments ADD CONSTRAINT person_fk FOREIGN KEY (person_id) REFERENCES contacts (id)"
    execute "ALTER TABLE rotation_assignments ADD CONSTRAINT rotation_fk FOREIGN KEY (rotation_id) REFERENCES rotations (id)"
    execute "ALTER TABLE rotation_assignments ADD CONSTRAINT editor_fk FOREIGN KEY (editor_id) REFERENCES users (id)"
    execute "ALTER TABLE rotation_assignments ADD CONSTRAINT rotation_schedule_fk FOREIGN KEY (rotation_schedule_id) REFERENCES rotation_schedules (id)"
  end

  def down
    execute "ALTER TABLE rotation_assignments DROP CONSTRAINT person_fk"
    execute "ALTER TABLE rotation_assignments DROP CONSTRAINT rotation_fk"
    execute "ALTER TABLE rotation_assignments DROP CONSTRAINT editor_fk"
    execute "ALTER TABLE rotation_assignments DROP CONSTRAINT rotation_schedule_fk"
    remove_index :rotation_assignments, :person_id
    remove_index :rotation_assignments, :rotation_id

    drop_table :rotation_assignments
  end
end
