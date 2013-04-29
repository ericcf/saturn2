class CreateAllowedShiftOverlaps < ActiveRecord::Migration
  def up
    create_table :allowed_shift_overlaps do |t|
      t.integer :shift_a_id, null: false
      t.integer :shift_b_id, null: false
    end

    add_index :allowed_shift_overlaps, [:shift_a_id, :shift_b_id], unique: true
    execute "alter table allowed_shift_overlaps add constraint shift_a_fk foreign key (shift_a_id) references shifts (id)"
    execute "alter table allowed_shift_overlaps add constraint shift_b_fk foreign key (shift_b_id) references shifts (id)"
  end

  def down
    remove_index :allowed_shift_overlaps, [:shift_a_id, :shift_b_id]
    execute "alter table allowed_shift_overlaps drop constraint shift_a_fk"
    execute "alter table allowed_shift_overlaps drop constraint shift_b_fk"
    drop_table :allowed_shift_overlaps
  end
end
