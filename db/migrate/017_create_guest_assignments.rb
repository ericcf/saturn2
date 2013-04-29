class CreateGuestAssignments < ActiveRecord::Migration
  def up
    create_table :guest_assignments do |t|
      t.integer :shift_id,            null: false
      t.integer :guest_membership_id, null: false
      t.date :date,                   null: false
      t.integer :editor_id

      t.timestamps
    end

    add_index :guest_assignments, [:guest_membership_id, :shift_id, :date], unique: true, name: 'guest_shift_date_index'
    execute "ALTER TABLE guest_assignments ADD CONSTRAINT shift_fk FOREIGN KEY (shift_id) REFERENCES shifts (id)"
    execute "ALTER TABLE guest_assignments ADD CONSTRAINT guest_membership_fk FOREIGN KEY (guest_membership_id) REFERENCES guest_memberships (id)"
    execute "ALTER TABLE guest_assignments ADD CONSTRAINT editor_fk FOREIGN KEY (editor_id) REFERENCES users (id)"
  end

  def down
    remove_index :guest_assignments, name: 'guest_shift_date_index'
    execute "ALTER TABLE guest_assignments DROP CONSTRAINT shift_fk"
    execute "ALTER TABLE guest_assignments DROP CONSTRAINT guest_membership_fk"
    execute "ALTER TABLE guest_assignments DROP CONSTRAINT editor_fk"
    drop_table :guest_assignments
  end
end
