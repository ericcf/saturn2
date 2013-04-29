require 'spec_helper'

describe GuestAssignment do
  fixtures :shifts, :guest_memberships, :users

  subject(:assignment) { GuestAssignment.create!(shift: shifts(:default), guest_membership: guest_memberships(:default), date: Date.today) }

  specify "db prevents invalid shift" do
    a = assignment.dup.tap { |a| a.shift_id = 0 }
    expect { a.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents shift delete" do
    expect { assignment.shift.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid shift destroy" do
    shift = assignment.shift.tap { |s| s.destroy }
    GuestAssignment.where(shift_id: shift).count.should eq(0)
  end

  specify "db prevents invalid guest membership" do
    a = assignment.dup.tap { |a| a.guest_membership_id = 0 }
    expect { a.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents guest membership delete" do
    expect { assignment.guest_membership.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid guest membership destroy" do
    guest_membership = assignment.guest_membership.tap { |m| m.destroy }
    GuestAssignment.where(guest_membership_id: guest_membership).count.should eq(0)
  end
end
