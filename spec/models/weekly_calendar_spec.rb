require 'spec_helper'

describe WeeklyCalendar do
  fixtures :schedules

  let(:valid_attributes) do
    {
      schedule: schedules(:general),
      date:     Date.today.at_beginning_of_week + 20*7
    }
  end

  subject(:calendar) { WeeklyCalendar.create!(valid_attributes) }

  before do
    schedules(:general)
    Schedule.stub!(:find).with(schedules(:general).id).
      and_return(schedules(:general))
  end

  describe ".include_dates" do

    it "returns schedules that include the dates" do
      WeeklyCalendar.include_dates([calendar.date]).
        should include(calendar)
    end

    it "does not return schedules that do not include the dates" do
      WeeklyCalendar.include_dates([calendar.date - 1.year]).
        should_not include(calendar)
    end
  end

  describe "#shift_weeks_json" do

    it "serializes the object as valid json" do
      expect { JSON.parse(calendar.to_json) }.
        to_not raise_error(JSON::ParserError)
    end
  end

  specify "db prevents invalid schedule" do
    cal = calendar.dup.tap { |c| c.schedule_id = 0 }
    expect { cal.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents schedule delete" do
    expect { calendar.schedule.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid schedule destroy" do
    schedule = calendar.schedule.tap { |s| s.destroy }
    WeeklyCalendar.where(schedule_id: schedule).count.should eq(0)
  end

  specify "db prevents duplicate date and schedule_id pair" do
    cal = calendar.dup
    expect { cal.save(validate: false) }.to raise_error(ActiveRecord::StatementInvalid)
  end
end
