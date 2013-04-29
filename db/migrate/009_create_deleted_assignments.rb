class CreateDeletedAssignments < ActiveRecord::Migration
  def up
    create_table :deleted_assignments do |t|
      t.integer :shift_id,     null: false
      t.integer :person_id, null: false
      t.date :date
      t.string :public_note
      t.string :private_note
      t.decimal :duration,     precision: 2, scale: 1
      t.time :starts_at
      t.time :ends_at
      t.integer :label_id
      t.integer :editor_id
      t.datetime :original_created_at
      t.datetime :updated_at
    end

    execute "ALTER TABLE deleted_assignments ADD CONSTRAINT shift_fk FOREIGN KEY (shift_id) REFERENCES shifts (id)"
    execute "ALTER TABLE deleted_assignments ADD CONSTRAINT person_fk FOREIGN KEY (person_id) REFERENCES contacts (id)"
    execute "ALTER TABLE deleted_assignments ADD CONSTRAINT label_fk FOREIGN KEY (label_id) REFERENCES assignment_labels (id)"
    execute "ALTER TABLE deleted_assignments ADD CONSTRAINT editor_fk FOREIGN KEY (editor_id) REFERENCES users (id)"
  end

  def down
    execute "ALTER TABLE deleted_assignments DROP CONSTRAINT shift_fk"
    execute "ALTER TABLE deleted_assignments DROP CONSTRAINT person_fk"
    execute "ALTER TABLE deleted_assignments DROP CONSTRAINT label_fk"
    execute "ALTER TABLE deleted_assignments DROP CONSTRAINT editor_fk"

    drop_table :deleted_assignments
  end
end
