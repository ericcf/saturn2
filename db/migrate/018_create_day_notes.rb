class CreateDayNotes < ActiveRecord::Migration
  def up
    create_table :day_notes do |t|
      t.integer :schedule_id, null: false
      t.date :date,           null: false
      t.string :public_text
      t.string :private_text
    end

    add_index :day_notes, [:schedule_id, :date], unique: true
    execute "ALTER TABLE day_notes ADD CONSTRAINT schedule_fk FOREIGN KEY (schedule_id) REFERENCES schedules (id)"
  end

  def down
    remove_index :day_notes, [:schedule_id, :date]
    execute "ALTER TABLE day_notes DROP CONSTRAINT schedule_fk"
    drop_table :day_notes
  end
end
