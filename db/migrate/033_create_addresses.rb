class CreateAddresses < ActiveRecord::Migration
  def up
    create_table :addresses do |t|
      t.integer :contact_id,               null: false
      t.string :institution
      t.string :department
      t.string :street,                    null: false
      t.string :building_floor_suite_room
      t.string :city,                      null: false
      t.string :state,                     null: false
      t.string :zip,                       null: false
    end

    add_index :addresses, :contact_id, unique: true
    execute "alter table addresses add constraint contact_fk foreign key (contact_id) references contacts (id)"
  end

  def down
    remove_index :addresses, :contact_id
    execute "alter table addresses drop constraint contact_fk"
    drop_table :addresses
  end
end
