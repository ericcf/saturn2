class CreateNmffStatuses < ActiveRecord::Migration
  def up
    create_table :nmff_statuses do |t|
      t.integer :person_id, null: false
      t.date :hire_date,       null: false
      t.decimal :fte,          null: false, default: 1.0, precision: 3, scale: 2
      t.text :carryover
    end

    add_index :nmff_statuses, :person_id, unique: true
    execute "alter table nmff_statuses add constraint person_fk foreign key (person_id) references contacts (id)"
    execute "ALTER TABLE nmff_statuses ADD CONSTRAINT fte_valid CHECK (fte >= 0 AND fte <= 1)"
  end

  def down
    remove_index :nmff_statuses, :person_id
    execute "alter table nmff_statuses drop constraint person_fk"
    execute "ALTER TABLE nmff_statuses DROP CONSTRAINT fte_valid"
    drop_table :nmff_statuses
  end
end
