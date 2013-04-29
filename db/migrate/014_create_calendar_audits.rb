class CreateCalendarAudits < ActiveRecord::Migration
  def up
    create_table :calendar_audits do |t|
      t.integer :schedule_id, null: false
      t.date :date,           null: false
      t.text :log,            null: false
      t.datetime :updated_at
    end

    execute "alter table calendar_audits add constraint schedule_fk foreign key (schedule_id) references schedules (id)"
  end

  def down
    execute "alter table calendar_audits drop constraint schedule_fk"
    drop_table :calendar_audits
  end
end
