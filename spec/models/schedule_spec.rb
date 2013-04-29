require 'spec_helper'

describe Schedule do
  let(:valid_attributes) do
    {
      title: "Foo"
    }
  end
  subject(:schedule) { Schedule.create!(valid_attributes) }

  specify "db prevents invalid vacation request window" do
    sched = schedule.dup.tap { |s| s.vacation_request_min_days_advance = 10; s.vacation_request_max_days_advance = 1 }
    expect { sched.save(validate: false) }.to raise_error(ActiveRecord::StatementInvalid)
  end
end
