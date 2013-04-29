class CreateEvents < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string :title,        null: false
      t.date :start_date,     null: false
      t.date :end_date,       null: false
      t.integer :schedule_id, null: false

      t.timestamps
    end

    execute "ALTER TABLE events ADD CONSTRAINT dates_valid CHECK (start_date <= end_date)"
    execute "ALTER TABLE events ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules (id)"
  end

  def down
    execute "ALTER TABLE events DROP CONSTRAINT dates_valid"
    execute "ALTER TABLE events DROP CONSTRAINT schedule_fk"
    drop_table :events
  end
end
