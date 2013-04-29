class CreateAssignmentLabels < ActiveRecord::Migration
  def up
    create_table :assignment_labels do |t|
      t.integer :shift_id, null: false
      t.string :text,      null: false
    end

    add_index :assignment_labels, [:text, :shift_id], unique: true
    execute "alter table assignment_labels add constraint shift_fk foreign key (shift_id) references shifts (id)"
  end

  def down
    remove_index :assignment_labels, [:text, :shift_id]
    execute "alter table assignment_labels drop constraint shift_fk"
    drop_table :assignment_labels
  end
end
