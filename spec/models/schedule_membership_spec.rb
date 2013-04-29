require 'spec_helper'

describe ScheduleMembership do
  fixtures :schedules, :people

  let(:valid_attributes) do
    {
      person: people(:resident_pat),
      schedule:  schedules(:general)
    }
  end
  subject(:membership) { ScheduleMembership.create!(valid_attributes) }
  
  before do
    schedules(:general)
    Schedule.stub!(:find).with(schedules(:general).id, anything) { schedules(:general) }
  end

  it { membership.person.should eq(people(:resident_pat)) }

  it { membership.update_attributes(initials: " "); membership.initials.should be_nil }

  specify "db prevents invalid schedule" do
    m = membership.dup.tap { |m| m.schedule_id = 0 }
    expect { m.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents schedule delete" do
    expect { membership.schedule.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid schedule destroy" do
    schedule = membership.schedule.tap { |s| s.destroy }
    ScheduleMembership.where(schedule_id: schedule).count.should eq(0)
  end
end
