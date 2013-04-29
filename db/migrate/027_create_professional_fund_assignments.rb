class CreateProfessionalFundAssignments < ActiveRecord::Migration
  def up
    create_table :professional_fund_assignments do |t|
      t.integer :meeting_request_id
      t.string :meeting_request_type
      t.string :description
      t.integer :professional_fund_id

      t.timestamps
    end

    # no nice and easy way to add constraints for polymorphic association, so I'm skipping meeting_requests...
    execute "alter table professional_fund_assignments add constraint professional_fund_id_fk foreign key (professional_fund_id) references funding_sources (id)"
  end

  def down
    execute "alter table professional_fund_assignments drop constraint professional_fund_id_fk"

    drop_table :professional_fund_assignments
  end
end
