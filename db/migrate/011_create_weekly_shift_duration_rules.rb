class CreateWeeklyShiftDurationRules < ActiveRecord::Migration
  def up
    create_table :weekly_shift_duration_rules do |t|
      t.integer :schedule_id, null: false
      t.decimal :maximum,     precision: 4, scale: 1
      t.decimal :minimum,     precision: 4, scale: 1

      t.timestamps
    end

    add_index :weekly_shift_duration_rules, :schedule_id, unique: true
    execute "alter table weekly_shift_duration_rules add constraint schedule_fk foreign key (schedule_id) references schedules (id)"
    execute "ALTER TABLE weekly_shift_duration_rules ADD CONSTRAINT max_min_valid CHECK (maximum >= minimum AND maximum >= 0 AND maximum <= 999.9 and minimum >= 0 AND minimum <= 999.9)"
  end

  def down
    remove_index :weekly_shift_duration_rules, :schedule_id
    execute "alter table weekly_shift_duration_rules drop constraint schedule_fk"
    execute "ALTER TABLE weekly_shift_duration_rules DROP CONSTRAINT max_min_valid"
    drop_table :weekly_shift_duration_rules
  end
end
