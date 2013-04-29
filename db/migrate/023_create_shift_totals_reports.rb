class CreateShiftTotalsReports < ActiveRecord::Migration
  def up
    create_table :shift_totals_reports do |t|
      t.integer :creator_id,          null: false
      t.date :start_date,             null: false
      t.date :end_date
      t.boolean :end_date_is_today,   null: false
      t.boolean :include_unpublished, null: false
      t.text :shift_ids,              null: false
      t.text :groups,                 null: false
      t.boolean :hide_empty_shifts,   null: false
      t.integer :schedule_id,         null: false
    end

    execute "alter table shift_totals_reports add constraint creator_id_fk foreign key (creator_id) references users (id)"
    execute "alter table shift_totals_reports add constraint schedule_id_fk foreign key (schedule_id) references schedules (id)"
  end

  def down
    execute "alter table shift_totals_reports drop constraint schedule_id_fk"
    execute "alter table shift_totals_reports drop constraint creator_id_fk"
    drop_table :shift_totals_reports
  end
end
