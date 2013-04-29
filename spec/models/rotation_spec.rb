require 'spec_helper'

describe Rotation do
  let(:today) { Date.today }
  let(:yesterday) { today - 1 }
  let(:valid_attributes) do
    {
      title: "valid title",
      active_on: yesterday,
      retired_on: today
    }
  end

  subject(:rotation) { Rotation.create!(valid_attributes) }

  it "validates date order" do
    rotation.update_attributes(retired_on: yesterday).should be_false
  end

  specify "db validates date order" do
    expect { rotation.update_column(:retired_on, yesterday) }.to raise_error(ActiveRecord::StatementInvalid)
  end
end
