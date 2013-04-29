require 'spec_helper'

describe ScheduleRotation do
  fixtures :schedules, :rotations

  subject { ScheduleRotation.create!(schedule: schedules(:general), rotation: rotations(:default)) }

  specify "db prevents invalid schedule" do
    schedule_rotation = subject.dup.tap { |a| a.schedule_id = 0 }
    expect { schedule_rotation.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents schedule delete" do
    expect { subject.schedule.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid schedule destroy" do
    schedule = subject.schedule.tap { |s| s.destroy }
    ScheduleRotation.where(schedule_id: schedule).count.should eq(0)
  end

  specify "db prevents invalid rotation" do
    schedule_rotation = subject.dup.tap { |s| s.rotation_id = 0 }
    expect { schedule_rotation.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents rotation delete" do
    expect { subject.rotation.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid rotation destroy" do
    rotation = subject.rotation.tap { |r| r.destroy }
    ScheduleRotation.where(rotation_id: rotation).count.should eq(0)
  end
end
