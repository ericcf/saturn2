class CreateWeeklyCalendars < ActiveRecord::Migration
  def up
    create_table :weekly_calendars do |t|
      t.integer :schedule_id,  null: false
      t.date :date,            null: false
      t.boolean :is_published, null: false, default: false

      t.timestamps
    end

    add_index :weekly_calendars, [:date, :schedule_id], unique: true
    execute "alter table weekly_calendars add constraint schedule_fk foreign key (schedule_id) references schedules (id)"
  end

  def down
    remove_index :weekly_calendars, [:date, :schedule_id]
    execute "alter table weekly_calendars drop constraint schedule_fk"
    drop_table :weekly_calendars
  end
end
