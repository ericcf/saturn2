class CreateVacationRequests < ActiveRecord::Migration
  def up
    create_table :vacation_requests do |t|
      t.integer  "requester_id",               null: false
      t.integer  "schedule_id",                null: false
      t.integer  "shift_id",                   null: false
      t.string   "status",                     null: false, limit: 60
      t.date     "start_date",                 null: false
      t.date     "end_date",                   null: false
      t.text     "comments"
      t.integer  "person_id",               null: false
      t.text     "events",                     null: false

      t.timestamps
    end

    add_index "vacation_requests", :requester_id
    add_index "vacation_requests", :status
    execute "alter table vacation_requests add constraint requester_fk foreign key (requester_id) references users (id)"
    execute "alter table vacation_requests add constraint schedule_fk foreign key (schedule_id) references schedules (id)"
    execute "alter table vacation_requests add constraint shift_fk foreign key (shift_id) references shifts (id)"
    execute "alter table vacation_requests add constraint person_fk foreign key (person_id) references contacts (id)"
  end

  def down
    remove_index :vacation_requests, :requester_id
    remove_index :vacation_requests, :status
    execute "alter table vacation_requests drop constraint requester_fk"
    execute "alter table vacation_requests drop constraint schedule_fk"
    execute "alter table vacation_requests drop constraint shift_fk"
    execute "alter table vacation_requests drop constraint person_fk"
    drop_table :vacation_requests
  end
end
