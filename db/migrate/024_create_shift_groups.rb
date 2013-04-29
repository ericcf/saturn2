class CreateShiftGroups < ActiveRecord::Migration
  def up
    create_table :shift_groups do |t|
      t.string :title,        null: false
      t.integer :schedule_id, null: false
      t.text :shift_ids
      t.integer :position,    null: false, default: 0
    end
    execute "alter table shift_groups add constraint schedule_id_fk foreign key (schedule_id) references schedules (id)"
  end

  def down
    execute "alter table shift_groups drop constraint schedule_id_fk"
    drop_table :shift_groups
  end
end
