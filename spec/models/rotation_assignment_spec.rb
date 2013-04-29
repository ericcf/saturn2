require 'spec_helper'

describe RotationAssignment do
  fixtures :rotations, :rotation_schedules, :people

  let(:today) { Date.today }
  let(:yesterday) { today - 1 }
  let(:tomorrow) { today + 1 }
  let(:valid_attributes) do
    {
      person:            people(:resident_isabel),
      rotation:          rotations(:default),
      rotation_schedule: rotation_schedules(:default),
      starts_on:         today,
      ends_on:           tomorrow
    }
  end

  subject { RotationAssignment.create!(valid_attributes) }

  before do
    subject
  end

  it "should not allow ends_on to occur before starts_on" do
    RotationAssignment.create(valid_attributes.merge({
      starts_on: Date.today,
      ends_on: Date.yesterday
    })).should_not be_valid
  end

  it "should not allow overlapping assignments" do
    [
      { starts_on: today, ends_on: tomorrow },
      { starts_on: yesterday, ends_on: tomorrow }
    ].each do |attrs|
      assignment = RotationAssignment.create(valid_attributes.merge(attrs))
      assignment.errors[:base].should_not be_blank
    end
  end

  it "should allow non-overlapping assignments" do
    [
      { starts_on: tomorrow, ends_on: tomorrow },
      { starts_on: yesterday, ends_on: today }
    ].each do |attrs|
      assignment = RotationAssignment.create(valid_attributes.merge(attrs))
      assignment.errors[:base].should be_blank
    end
  end

  it "should allow assignment updates" do
    subject.update_attributes(starts_on: yesterday).should be_true
  end

  specify "db prevents invalid rotation" do
    assignment = subject.dup.tap { |a| a.rotation_id = 0 }
    expect { assignment.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents rotation delete" do
    expect { subject.rotation.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid rotation destroy" do
    rotation = subject.rotation.tap { |r| r.destroy }
    RotationAssignment.where(rotation_id: rotation).count.should eq(0)
  end

  specify "db prevents invalid rotation schedule" do
    schedule = subject.dup.tap { |a| a.rotation_schedule_id = 0 }
    expect { schedule.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents rotation schedule delete" do
    expect { subject.rotation_schedule.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid rotation schedule destroy" do
    schedule = subject.rotation_schedule.tap { |s| s.destroy }
    RotationAssignment.where(rotation_schedule_id: schedule).count.should eq(0)
  end
end
