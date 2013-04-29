require 'spec_helper'

describe AdminAssignment do
  fixtures :users, :schedules

  subject(:assignment) { AdminAssignment.create!(user: users(:default), schedule: schedules(:general)) }

  specify "db prevents invalid user" do
    a = assignment.dup.tap { |a| a.user_id = 0 }
    expect { a.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents invalid user delete" do
    expect { assignment.user.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid user destroy" do
    user = assignment.user.tap { |u| u.destroy }
    AdminAssignment.where(user_id: user).count.should eq(0)
  end

  specify "db prevents invalid schedule" do
    a = assignment.dup.tap { |a| a.schedule_id = 0 }
    expect { a.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents invalid schedule delete" do
    expect { assignment.schedule.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid schedule destroy" do
    schedule = assignment.schedule.tap { |u| u.destroy }
    AdminAssignment.where(schedule_id: schedule).count.should eq(0)
  end
end
