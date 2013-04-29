require 'spec_helper'

describe DayNote do
  fixtures :schedules

  subject(:note) { DayNote.create!(schedule: schedules(:general), date: Date.today) }

  specify "db prevents invalid schedule" do
    n = note.dup.tap { |n| n.schedule_id = 0 }
    expect { n.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents schedule delete" do
    expect { note.schedule.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid schedule destroy" do
    schedule = note.schedule.tap { |s| s.destroy }
    DayNote.where(schedule_id: schedule).count.should eq(0)
  end
end
