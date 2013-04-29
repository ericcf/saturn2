require 'spec_helper'

describe Event do
  fixtures :schedules

  subject(:event) { Event.create!(schedule: schedules(:general), title: 'Party', start_date: Date.today, end_date: Date.tomorrow) }

  specify "db prevents invalid schedule" do
    e = event.dup.tap { |e| e.schedule_id = 0 }
    expect { e.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents schedule delete" do
    expect { event.schedule.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid schedule destroy" do
    schedule = event.schedule.tap { |s| s.destroy }
    Event.where(schedule_id: schedule).count.should eq(0)
  end

  specify "db prevents invalid dates" do
    expect { event.update_column(:end_date, Date.yesterday) }.to raise_error(ActiveRecord::StatementInvalid)
  end
end
