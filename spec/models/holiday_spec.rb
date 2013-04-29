require 'spec_helper'

describe Holiday do
  let(:valid_attributes) do
    {
      date:  Date.today,
      title: "Pee Wee's Birthday"
    }
  end
  subject(:holiday) { Holiday.create!(valid_attributes) }

  it { holiday.to_s.should eq("Pee Wee's Birthday") }
end
