require 'spec_helper'

describe PublishedShiftWeek do
  fixtures :schedules, :shifts, :schedule_shifts, :weekly_calendars

  describe "scope" do

    subject { PublishedShiftWeek }

    context "active schedule shift" do

      let(:active_shift) { schedule_shifts(:active).shift }

      context "during unpublished weeks" do

        context "shifts not shown unpublished" do

          before do
            active_shift.update_column(:show_unpublished, false)
          end

          it do
            subject.where("? = any(dates)", weekly_calendars(:unpublished).date).map(&:shift_id).
              should_not include(active_shift.id)
          end
        end

        context "schedule shifts shown unpublished" do

          before do
            active_shift.update_column(:show_unpublished, true)
          end

          it do
            subject.where("? = any(dates)", weekly_calendars(:unpublished).date).map(&:shift_id).
              should include(active_shift.id)
          end
        end
      end

      it "during published weeks" do
        subject.where("? = any(dates)", weekly_calendars(:published).date).map(&:shift_id).
          should include(active_shift.id)
      end
    end

    context "retired schedule shift" do

      let(:retired_date) { Date.today }
      let(:retired_shift) do
        schedule_shifts(:retired).tap { |s| s.update_column(:retired_on, retired_date) }.shift
      end

      context "during past published weeks" do

        let(:published_calendar) do
          weekly_calendars(:published).tap { |c| c.update_column(:date, retired_date - 7) }
        end

        it do
          subject.where("? = any(dates)", published_calendar.date).map(&:shift_id).
            should include(retired_shift.id)
        end
      end

      context "during future published weeks" do

        let(:published_calendar) do
          weekly_calendars(:published).tap { |c| c.update_column(:date, retired_date + 7) }
        end

        it do
          subject.where("? = any(dates)", published_calendar.date).map(&:shift_id).
            should_not include(retired_shift.id)
        end
      end
    end
  end
end
