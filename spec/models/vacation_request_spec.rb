require 'spec_helper'

describe VacationRequest do
  fixtures :people, :vacation_requests, :schedules, :shifts

  describe 'validations' do

    describe '#no_overlap_with_other_pending_requests' do

      let(:pending_req) { vacation_requests(:requested) }

      context 'overlap with another pending request' do

        subject { pending_req.dup }

        it { subject.errors_on(:base).should include('dates cannot overlap an existing request') }
      end

      context 'overlap with a non-pending request' do

        let(:denied_req) { vacation_requests(:denied) }
        let!(:cancelled_req) { vacation_requests(:cancelled) }
        subject { denied_req.dup.tap { |r| r.status = 'submitted' } }

        it { should have(0).errors_on(:base) }
      end

      context 'no overlap with another pending request' do

        subject { pending_req.dup.tap { |r| r.start_date = pending_req.end_date + 1; r.end_date = r.start_date } }

        it { should have(0).errors_on(:base) }
      end
    end

    describe '#no_overlap_with_assigned_vacation' do

      let(:schedule) { schedules(:general).tap { |s| s.memberships.create!(person: people(:attending_mary)) } }
      let(:vacation_shift) { schedule.shifts << shifts(:vacation); shifts(:vacation) }
      let!(:vacation_assignment) { vacation_shift.assignments.create!(date: Date.tomorrow, person: people(:attending_mary)) }

      subject { vacation_requests(:requested).dup.tap { |r| r.update_attributes(start_date: Date.tomorrow, end_date: Date.tomorrow, schedule: schedule) } }

      it { subject.errors_on(:base).should include('dates cannot overlap existing vacation') }
    end
  end
end
