class CreateAssignments < ActiveRecord::Migration
  def up
    create_table :assignments do |t|
      t.integer :shift_id,    null: false
      t.integer :person_id,   null: false
      t.date :date,           null: false
      t.string :public_note
      t.string :private_note
      t.decimal :duration,    precision: 2, scale: 1
      t.time :starts_at
      t.time :ends_at
      t.integer :label_id
      t.integer :editor_id

      t.timestamps
    end

    add_index :assignments, [:date, :person_id, :shift_id], unique: true
    execute "alter table assignments add constraint shift_fk foreign key (shift_id) references shifts (id)"
    execute "alter table assignments add constraint person_fk foreign key (person_id) references contacts (id)"
    execute "alter table assignments add constraint label_fk foreign key (label_id) references assignment_labels (id)"
    execute "alter table assignments add constraint editor_fk foreign key (editor_id) references users (id)"
  end

  def down
    remove_index :assignments, [:date, :person_id, :shift_id]
    execute "alter table assignments drop constraint shift_fk"
    execute "alter table assignments drop constraint person_fk"
    execute "alter table assignments drop constraint label_fk"
    execute "alter table assignments drop constraint editor_fk"
    drop_table :assignments
  end
end
