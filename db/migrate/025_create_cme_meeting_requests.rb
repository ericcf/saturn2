class CreateCmeMeetingRequests < ActiveRecord::Migration
  def up
    create_table :cme_meeting_requests do |t|
      t.integer  "requester_id",               null: false
      t.integer  "schedule_id",                null: false
      t.integer  "shift_id",                   null: false
      t.string   "status",                     null: false, limit: 60
      t.date     "start_date",                 null: false
      t.date     "end_date",                   null: false
      t.date     "meeting_start_date",         null: false
      t.date     "meeting_end_date",           null: false
      t.string   "description",                null: false
      t.integer  "person_id",                  null: false
      t.text     "events",                     null: false

      t.timestamps
    end

    execute "alter table cme_meeting_requests add constraint requester_id_fk foreign key (requester_id) references users (id)"
    execute "alter table cme_meeting_requests add constraint schedule_id_fk foreign key (schedule_id) references schedules (id)"
    execute "alter table cme_meeting_requests add constraint shift_id_fk foreign key (shift_id) references shifts (id)"
    execute "alter table cme_meeting_requests add constraint person_id_fk foreign key (person_id) references contacts (id)"
  end

  def down
    execute "alter table cme_meeting_requests drop constraint requester_id_fk"
    execute "alter table cme_meeting_requests drop constraint schedule_id_fk"
    execute "alter table cme_meeting_requests drop constraint shift_id_fk"
    execute "alter table cme_meeting_requests drop constraint person_id_fk"
    drop_table :cme_meeting_requests
  end
end
