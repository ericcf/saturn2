require 'spec_helper'

describe Shift do
  fixtures :schedules

  let(:valid_attributes) do
    {
      title: "value for title",
      schedules: [schedules(:general)]
    }
  end
  subject(:shift) { Shift.create!(valid_attributes) }
end
