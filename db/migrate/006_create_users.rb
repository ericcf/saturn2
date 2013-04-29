class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.boolean :admin,          default: false
      t.integer :person_id
      t.string :username,        null: false
      t.string :password_digest, null: false
      t.string :email,           null: false
      t.string :given_name
      t.string :family_name
      t.string :reset_token
      t.datetime :last_login_timestamp

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    execute "alter table users add constraint person_fk foreign key (person_id) references contacts (id)"
  end

  def down
    remove_index :users, :username
    remove_index :users, :email
    execute "alter table users drop constraint person_fk"
    drop_table :users
  end
end
