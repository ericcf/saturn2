require 'spec_helper'

describe WeeklyShiftDurationRule do
  fixtures :schedules

  subject(:rule) { WeeklyShiftDurationRule.create!(schedule: schedules(:general)) }

  it "is valid when the maximum is greater than the minimum" do
    rule.update_attributes(minimum: 0.0, maximum: 5.0)
    rule.should be_valid
  end

  it "is not valid when the maximum is less than the minimum" do
    rule.update_attributes(minimum: 10.0, maximum: 1.0)
    rule.should_not be_valid
  end

  it "is valid in the db when the maximum is greater than the minimum" do
    rule.minimum = 0.0; rule.maximum = 5.0
    expect { rule.save(validate: false) }.to_not raise_error
  end

  it "is not valid in the db when the maximum is less than the minimum" do
    rule.minimum = 5.0; rule.maximum = 0.0
    expect { rule.save(validate: false) }.to raise_error(ActiveRecord::StatementInvalid)
  end

  specify "db prevents invalid schedule" do
    r = rule.dup.tap { |r| r.schedule_id = 0 }
    expect { r.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents schedule delete" do
    expect { rule.schedule.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid schedule destroy" do
    schedule = rule.schedule.tap { |s| s.destroy }
    WeeklyShiftDurationRule.where(schedule_id: schedule).count.should eq(0)
  end
end
