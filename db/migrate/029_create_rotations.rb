class CreateRotations < ActiveRecord::Migration
  def up
    create_table :rotations do |t|
      t.string :title,         null: false
      t.date :active_on,       null: false, default: '1000-01-01'
      t.date :retired_on,      null: false, default: '9999-12-31'
      t.string :display_color, null: false, limit: 7, default: '#7A43B6'
    end

    execute "ALTER TABLE rotations ADD CONSTRAINT dates_valid CHECK (retired_on > active_on)"
  end

  def down
    execute "ALTER TABLE rotations DROP CONSTRAINT dates_valid"

    drop_table :rotations
  end
end
