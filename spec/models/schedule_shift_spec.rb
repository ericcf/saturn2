require 'spec_helper'

describe ScheduleShift do
  fixtures :schedules, :shifts

  subject(:schedule_shift) { ScheduleShift.create!(schedule: schedules(:general), shift: shifts(:default)) }

  describe ".active_as_of" do

    it "returns shifts with nil retired_on" do
      schedule_shift.update_attributes({ retired_on: nil })
      ScheduleShift.active_as_of(Date.today).should include(schedule_shift)
    end

    it "returns shifts with retired_on > cutoff_date" do
      schedule_shift.update_attributes({ retired_on: Date.tomorrow })
      ScheduleShift.active_as_of(Date.yesterday).should include(schedule_shift)
    end

    it "does not return shifts with retired_on < cutoff_date" do
      schedule_shift.update_attributes({ retired_on: Date.yesterday })
      ScheduleShift.active_as_of(Date.tomorrow).should_not include(schedule_shift)
    end
  end

  describe ".retired_as_of" do

    it "does not return schedule_shifts with retired_on == nil" do
      schedule_shift.update_attributes({ retired_on: nil })
      ScheduleShift.retired_as_of(Date.today).should_not include(schedule_shift)
    end

    it "returns schedule_shifts with retired_on < cutoff_date" do
      schedule_shift.update_attributes({ retired_on: Date.yesterday })
      ScheduleShift.retired_as_of(Date.tomorrow).should include(schedule_shift)
    end

    it "does not return schedule_shifts with retired_on > cutoff_date" do
      schedule_shift.update_attributes({ retired_on: Date.tomorrow })
      ScheduleShift.retired_as_of(Date.yesterday).should_not include(schedule_shift)
    end
  end

  describe "#retire=" do

    context "value is like true" do

      it "retired_on is set to today" do
        schedule_shift.retire = "1"
        schedule_shift.retired_on.should == Date.today
      end
    end
  end

  specify "db prevents invalid schedule" do
    ss = schedule_shift.dup.tap { |a| a.schedule_id = 0 }
    expect { ss.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents schedule delete" do
    expect { schedule_shift.schedule.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid schedule destroy" do
    schedule = schedule_shift.schedule.tap { |s| s.destroy }
    ScheduleShift.where(schedule_id: schedule).count.should eq(0)
  end

  specify "db prevents invalid shift" do
    ss = schedule_shift.dup.tap { |s| s.shift_id = 0 }
    expect { ss.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents shift delete" do
    expect { schedule_shift.shift.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid shift destroy" do
    shift = schedule_shift.shift.tap { |s| s.destroy }
    ScheduleShift.where(shift_id: shift).count.should eq(0)
  end
end
