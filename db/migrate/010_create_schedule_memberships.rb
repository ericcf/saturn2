class CreateScheduleMemberships < ActiveRecord::Migration
  def up
    create_table :schedule_memberships do |t|
      t.integer :person_id,             null: false
      t.integer :schedule_id,           null: false
      t.decimal :fte,                   precision: 3, scale: 2, default: 1.0, null: false
      t.string :initials
      t.boolean :disable_notifications, null: false, default: false
    end

    add_index :schedule_memberships, [:person_id, :schedule_id], unique: true
    execute "ALTER TABLE schedule_memberships ADD CONSTRAINT person_fk FOREIGN KEY (person_id) REFERENCES contacts (id)"
    execute "ALTER TABLE schedule_memberships ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules (id)"
    execute "ALTER TABLE schedule_memberships ADD CONSTRAINT fte_valid CHECK (fte > 0 AND fte <= 1)"
  end

  def down
    execute "ALTER TABLE schedule_memberships DROP CONSTRAINT fte_valid"
    execute "ALTER TABLE schedule_memberships DROP CONSTRAINT schedule_fk"
    execute "ALTER TABLE schedule_memberships DROP CONSTRAINT person_fk"
    remove_index :schedule_memberships, [:person_id, :schedule_id]
    drop_table :schedule_memberships
  end
end
