class CreateGuestMemberships < ActiveRecord::Migration
  def up
    create_table :guest_memberships do |t|
      t.integer :schedule_id
      t.string :family_name
      t.string :given_name

      t.timestamps
    end

    execute "alter table guest_memberships add constraint schedule_fk foreign key (schedule_id) references schedules (id)"
  end

  def down
    execute "alter table guest_memberships drop constraint schedule_fk"
    drop_table :guest_memberships
  end
end
