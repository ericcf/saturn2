class CreateOutsideFundAssignments < ActiveRecord::Migration
  def up
    create_table :outside_fund_assignments do |t|
      t.integer :meeting_request_id
      t.string :meeting_request_type
      t.string :description
      t.integer :outside_source_fund_id

      t.timestamps
    end

    execute "alter table outside_fund_assignments add constraint outside_source_fund_id_fk foreign key (outside_source_fund_id) references funding_sources (id)"
  end

  def down
    execute "alter table outside_fund_assignments drop constraint outside_source_fund_id_fk"

    drop_table :outside_fund_assignments
  end
end
