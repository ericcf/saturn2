require 'spec_helper'

describe GuestMembership do
  fixtures :schedules

  subject(:membership) { GuestMembership.create!(schedule: schedules(:general), family_name: 'Bar', given_name: 'Foo') }

  specify "db prevents invalid schedule" do
    m = membership.dup.tap { |m| m.schedule_id = 0 }
    expect { m.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents schedule delete" do
    expect { membership.schedule.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid schedule destroy" do
    schedule = membership.schedule.tap { |s| s.destroy }
    GuestMembership.where(schedule_id: schedule).count.should eq(0)
  end
end
