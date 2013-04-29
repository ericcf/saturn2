class CreateHolidays < ActiveRecord::Migration
  def change
    create_table :holidays do |t|
      t.string :title, null: false
      t.date :date,    null: false
    end

    add_index :holidays, :date
  end
end
