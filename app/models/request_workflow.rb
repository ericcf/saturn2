class RequestWorkflow
  ACTION_PAST_TENSE = {
    'submit'  => 'submitted',
    'approve' => 'approved',
    'deny'    => 'denied',
    'cancel'  => 'cancelled'
  }

  STATES = [
    'requested',
    'cancelled',
    'approved',
    'denied',
    'cancellation requested',
    'cancellation denied'
  ]

  TRANSITION = {
    [nil, 'submit']                       => 'requested',
    ['requested', 'cancel']               => 'cancelled',
    ['requested', 'approve']              => 'approved',
    ['requested', 'deny']                 => 'denied',
    ['approved', 'cancel']                => 'cancellation requested',
    ['cancellation requested', 'approve'] => 'cancelled',
    ['cancellation requested', 'deny']    => 'cancellation denied'
  }

  def initialize(assignment_request)
    @assignment_request = assignment_request
  end

  def submit
    transition 'submit'
  end

  def approve
    transition 'approve'
  end

  def cancel
    transition 'cancel'
  end

  def deny
    transition 'deny'
  end

  private

  def transition(action)
    new_status = TRANSITION[[@assignment_request.status, action]]
    @assignment_request.status = new_status
    @assignment_request.log_event ACTION_PAST_TENSE[action]
    if @assignment_request.save
      case new_status
      when 'cancelled', 'denied'
        @assignment_request.destroy_assignments
      when 'approved'
        @assignment_request.create_assignments
      end
      true
    else
      false
    end
  end
end
