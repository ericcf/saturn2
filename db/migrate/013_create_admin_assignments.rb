class CreateAdminAssignments < ActiveRecord::Migration
  def up
    create_table :admin_assignments do |t|
      t.integer :user_id,                        null: false
      t.integer :schedule_id,                    null: false
      t.boolean :is_vacation_request_subscriber, null: false, default: true
    end

    execute "ALTER TABLE admin_assignments ADD CONSTRAINT user_fk FOREIGN KEY (user_id) REFERENCES users (id)"
    execute "ALTER TABLE admin_assignments ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules (id)"
    add_index :admin_assignments, [:schedule_id, :user_id], unique: true
  end

  def down
    remove_index :admin_assignments, [:schedule_id, :user_id]
    execute "ALTER TABLE admin_assignments DROP CONSTRAINT user_fk"
    execute "ALTER TABLE admin_assignments DROP CONSTRAINT schedule_fk"
    drop_table :admin_assignments
  end
end
