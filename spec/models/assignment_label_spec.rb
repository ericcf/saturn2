require 'spec_helper'

describe AssignmentLabel do
  fixtures :shifts, :assignment_labels

  subject(:label) { AssignmentLabel.create!(shift: shifts(:default), text: 'Foo') }

  specify "db prevents invalid shift" do
    l = label.dup.tap { |l| l.shift_id = 0 }
    expect { l.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents shift delete" do
    expect { label.shift.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "prevents invalid shift destroy" do
    shift = label.shift.tap { |s| s.destroy }
    AssignmentLabel.where(shift_id: shift).count.should == 0
  end

  describe ".find_or_create_like" do

    let(:label) { assignment_labels(:default) }

    context "with blank text" do

      it "returns nil" do
        AssignmentLabel.find_or_create_like('shift_id', '').should be_nil
      end
    end

    context "when one exists for the shift" do

      it "returns the label" do
        AssignmentLabel.find_or_create_like(label.shift_id, 'abc').should == label
      end
    end

    context "when one does not exist" do

      it "returns the new label" do
        expect {
          AssignmentLabel.find_or_create_like(label.shift_id, 'zyx')
        }.to change{AssignmentLabel.count}
      end
    end
  end
end
