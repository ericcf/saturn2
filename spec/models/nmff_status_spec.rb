require 'spec_helper'

describe NmffStatus do
  fixtures :people

  describe "#quarterly_allotted_days" do

    context "the hire date occurs after the quarter ends" do

      subject { NmffStatus.new(fte: 1.0, hire_date: Date.new(2011, 12, 1)) }

      it { subject.quarterly_allotted_days(2012, 1).should eq({ count: 0.0, explain: nil }) }
    end

    context "the hire date was in the past" do

      context "fte 1.0" do

        subject { NmffStatus.new(fte: 1.0, hire_date: Date.new(2000, 1, 1)) }

        it "should add float day(s) to the first quarter" do
          subject.quarterly_allotted_days(2012, 1).should eq({ count: 7.25, explain: '6.25 + 1.0 (float)' })
        end
      end

      context "fte 0.6" do

        subject { NmffStatus.new(fte: 0.6, hire_date: Date.new(2000, 1, 1)) }

        it "should add float day(s) to the first quarter" do
          subject.quarterly_allotted_days(2012, 1).should eq({ count: 4.75, explain: '6.25 x 0.6 + 1.0 (float)' })
        end
      end
    end

    context "the hire date occurs during the current FY, before June 1" do

      context "the hire date occurs within the quarter" do

        subject { NmffStatus.new(fte: 1.0, hire_date: Date.new(2011, 12, 1)) }

        it "should add 1.0 days to the month of the hire date" do
          subject.quarterly_allotted_days(2012, 2).should eq({ count: 6.0, explain: '5.0 (prorated) + 1.0 (float)' })
        end
      end
    end

    context "the hire date occurs during the current FY, on or after June 1" do

      it "should not add days to the current FY" do
      end
    end
  end

  specify "db prevents duplicate person id" do
    NmffStatus.create!(fte: 1.0, hire_date: Date.today, person: people(:attending_mark))
    expect { NmffStatus.new(fte: 1.0, hire_date: Date.today, person: people(:attending_mark)).save(validate: false) }.to raise_error(ActiveRecord::StatementInvalid)
  end

  specify "db prevents invalid fte" do
    expect { NmffStatus.new(fte: 1.6, hire_date: Date.today, person: people(:attending_mary)).save(validate: false) }.to raise_error(ActiveRecord::StatementInvalid)
  end
end
