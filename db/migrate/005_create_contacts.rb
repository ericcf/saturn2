class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :type,               null: false
      t.string :given_name,         null: false
      t.string :slug
      t.string :other_given_names
      t.string :family_name
      t.string :photo_uid
      t.string :suffix
      t.string :titles
      t.string :degrees
      t.date :employment_starts_on
      t.date :employment_ends_on
      t.string :email
      t.string :phone
      t.string :fax
      t.string :pager
      t.string :alpha_pager
      t.integer :address_id
      t.string :pubmed_search_term
      t.string :netid

      t.timestamp :updated_at
    end
  end
end
