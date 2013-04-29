require 'spec_helper'

describe Assignment do
  fixtures :shifts, :people

  let(:today) { Date.today }
  let(:valid_attributes) do
    {
      shift:        shifts(:default),
      person:       people(:fellow_dietrich),
      date:         today,
      public_note:  "value for public_note",
      private_note: "value for private_note"
    }
  end
  subject(:assignment) { Assignment.create!(valid_attributes) }

  before do
    shifts(:default)
    Shift.stub!(:find).with(shifts(:default).id, anything) { shifts(:default) }
  end

  it "should validate uniqueness at the db level" do
    expect {
      assignment # reference it to instantiate the model
      assignment_dup = Assignment.new valid_attributes
      assignment_dup.save validate: false
    }.to raise_error(ActiveRecord::RecordNotUnique)
  end

  %w[ 07:00am 08:00pm ].each do |time|
    it { assignment.update_attributes(start_time: time).should be_true }
    it { assignment.update_attributes(end_time: time).should be_true }
  end

  describe "#label_text=" do

    context "when the text is not blank" do

      let(:mock_label) { mock("label") }

      before do
        AssignmentLabel.stub!(:find_or_create_like).with(assignment.shift_id, "lorem ipsum") { mock_label }
      end

      it "should save a reference to the label" do
        assignment.should_receive(:label=).with(mock_label)
        assignment.label_text = "lorem ipsum"
      end
    end

    context "when the text is blank" do

      it "should set the label to nil" do
        assignment.should_receive(:label=).with(nil)
        assignment.label_text = " "
      end
    end
  end

  describe ".in_date_range" do

    it "returns assignments with dates included in the range" do
      Assignment.in_date_range(assignment.date, assignment.date).
        should include(assignment)
    end

    it "does not return assignments with dates outside the range" do
      Assignment.in_date_range(assignment.date + 1, assignment.date + 2).
        should_not include(assignment)
    end
  end

  describe ".batch_create!" do

    let(:dates) { [today, today + 1.day] }
    let(:faculty_member_ids) { [1, 2] }
    let(:fellow_ids) { [3, 4] }
    let(:resident_ids) { [5, 6] }
    let(:person_ids) { faculty_member_ids + fellow_ids + resident_ids }
    let(:guest_ids) { [7, 8] }
    let(:person_params) do
      {
        shift_ids:          [shifts(:default).id],
        dates:              dates,
        faculty_member_ids: faculty_member_ids,
        fellow_ids:         fellow_ids,
        resident_ids:       resident_ids
      }
    end
    let(:guest_params) do
      {
        shift_ids: [shifts(:default).id],
        dates:     dates,
        guest_ids: guest_ids
      }
    end

    it "should create an assignment for each date/person combination" do
      dates.each do |date|
        person_ids.each do |id|
          Assignment.should_receive(:create!).with(shift_id: shifts(:default).id,
                                                   date: date,
                                                   person_id: id,
                                                   editor_id: nil)
        end
      end
      Assignment.batch_create! person_params
    end

    it "should create a guest assignment for each date/guest combination" do
      dates.each do |date|
        guest_ids.each do |id|
          GuestAssignment.should_receive(:create!).with(shift_id: shifts(:default).id,
                                                        date: date,
                                                        guest_membership_id: id,
                                                        editor_id: nil)
        end
      end
      Assignment.batch_create! guest_params
    end

    it "should raise ActiveRecord::ActiveRecordError if params are incomplete" do
      [:dates, :person_ids].each do |param|
        person_params.delete param
        lambda {
          Assignment.batch_create! person_params
        }.should raise_error(ActiveRecord::ActiveRecordError)
      end
    end
  end

  specify "db prevents invalid shift" do
    assignmt = assignment.dup.tap { |a| a.shift_id = 0 }
    expect { assignmt.save(validate: false) }.to raise_error(ActiveRecord::InvalidForeignKey)
  end

  specify "db prevents shift delete" do
    expect { assignment.shift.delete }.to raise_error(ActiveRecord::StatementInvalid)
  end

  it "allows valid shift destroy" do
    shift = assignment.shift.tap { |s| s.destroy }
    Assignment.where(shift_id: shift.id).count.should eq(0)
  end
end
