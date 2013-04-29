class CreateScheduleShifts < ActiveRecord::Migration
  def up
    create_table :schedule_shifts do |t|
      t.integer :schedule_id,         null: false
      t.integer :shift_id,            null: false
      t.integer :position,            null: false, default: 1
      t.string :display_color
      t.date :retired_on
      t.boolean :hide_from_aggregate, null: false, default: false
    end

    execute "alter table schedule_shifts add constraint schedule_fk foreign key (schedule_id) references schedules (id)"
    execute "alter table schedule_shifts add constraint shift_fk foreign key (shift_id) references shifts (id)"
  end

  def down
    execute "alter table schedule_shifts drop constraint schedule_fk"
    execute "alter table schedule_shifts drop constraint shift_fk"
    drop_table :schedule_shifts
  end
end
