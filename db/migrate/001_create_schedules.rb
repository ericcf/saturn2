class CreateSchedules < ActiveRecord::Migration
  def up
    create_table :schedules do |t|
      t.string :title,                              null: false
      t.boolean :open_reports,                      null: false, default: false
      t.boolean :allow_switch_offers,               null: false, default: false
      t.boolean :accept_vacation_requests,          null: false, default: false
      t.integer :vacation_request_max_days_advance, null: false, default: 0
      t.integer :vacation_request_min_days_advance, null: false, default: 0
      t.boolean :accept_meeting_requests,           null: false, default: false
      t.integer :meeting_request_max_days_advance,  null: false, default: 0
      t.integer :meeting_request_min_days_advance,  null: false, default: 0
    end

    add_index :schedules, :title, unique: true
    execute "ALTER TABLE schedules ADD CONSTRAINT vac_req_days_valid CHECK (vacation_request_min_days_advance <= vacation_request_max_days_advance AND vacation_request_min_days_advance >= 0 AND vacation_request_min_days_advance < 4000 AND vacation_request_max_days_advance >= 0 AND vacation_request_max_days_advance < 4000)"
    execute "ALTER TABLE schedules ADD CONSTRAINT meet_req_days_valid CHECK (meeting_request_min_days_advance <= meeting_request_max_days_advance AND meeting_request_min_days_advance >= 0 AND meeting_request_min_days_advance < 4000 AND meeting_request_max_days_advance >= 0 AND meeting_request_max_days_advance < 4000)"
  end

  def down
    execute "ALTER TABLE schedules DROP CONSTRAINT vac_req_days_valid"
    execute "ALTER TABLE schedules DROP CONSTRAINT meet_req_days_valid"
    remove_index :schedules, :title
    drop_table :schedules
  end
end
