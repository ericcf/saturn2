class CreateShifts < ActiveRecord::Migration
  def up
    create_table :shifts do |t|
      t.string :type
      t.string :title,             null: false
      t.decimal :duration,         null: false, precision: 2, scale: 1, default: 0.5
      t.string :phone
      t.time :starts_at,           null: false
      t.time :ends_at,             null: false
      t.boolean :show_unpublished, null: false, default: false
      t.text :recurrence

      t.datetime :updated_at
    end

    execute "ALTER TABLE shifts ADD CONSTRAINT type_valid CHECK (type IS NULL OR type IN ('CallShift', 'VacationShift', 'CmeMeetingShift'))"
  end

  def down
    execute "alter table shifts drop constraint type_valid"
    drop_table :shifts
  end
end
