class CmeMeetingRequest < ActiveRecord::Base
  WORKFLOW_TRANSITIONS = [
    { start: nil, action: 'submit', end: 'requested' },
    { start: 'requested', action: 'approve', end: 'approved', success: ->(request) { request.create_assignments } },
    { start: 'requested', action: 'deny', end: 'denied', success: ->(request) { request.destroy_assignments } },
    { start: 'requested', action: 'cancel', end: 'cancelled', success: ->(request) { request.destroy_assignments } }
  ]
  ACTION_PAST_TENSE = {
    'submit' => 'submitted',
    'approve' => 'approved',
    'deny' => 'denied',
    'cancel' => 'cancelled',
  }
  belongs_to :schedule
  belongs_to :requester, class_name: 'User'
  belongs_to :shift, class_name: 'CmeMeetingShift'
  belongs_to :physician

  has_many :professional_fund_assignments, :as => :meeting_request, :dependent => :destroy
  accepts_nested_attributes_for :professional_fund_assignments,
    :reject_if => lambda { |attr| attr['description'].blank? }
  has_many :professional_funds, :through => :professional_fund_assignments

  has_many :outside_fund_assignments, :as => :meeting_request, :dependent => :destroy
  accepts_nested_attributes_for :outside_fund_assignments,
    :reject_if => lambda { |attr| attr['description'].blank? }
  has_many :outside_source_funds, :through => :outside_fund_assignments

  serialize :events, Array

  validates :schedule, :requester, :physician, :shift, :status, :start_date, :end_date,
    :meeting_start_date, :meeting_end_date, :description, presence: true
  validates :status, inclusion: { in: WORKFLOW_TRANSITIONS.map { |t| t[:end] } }
  validates :description, length: { maximum: 255 }
  validate :dates_ordered
  validate :dates_within_accepted_window, on: :create

  delegate :short_name, :email, :to => :physician, :prefix => true

  def self.in_date_range(start_date, end_date)
    where("cme_meeting_requests.end_date >= ? AND cme_meeting_requests.start_date <= ?", start_date, end_date)
  end

  def self.upcoming
    where("end_date >= ?", Date.today)
  end

  def self.pending
    where(status: ['requested'])
  end

  def status=(value)
    self[:status] = value
    log_event ACTION_PAST_TENSE[value]
  end

  def create_assignments
    (start_date..end_date).each do |date|
      shift.assignments.create(physician_id: physician_id, date: date)
    end
  end

  def destroy_assignments
    assignments.each(&:destroy)
  end

  def destroyed_assignments
    (start_date..end_date).map { |d| "#{self.class.to_s}#{id}_#{d}" }
  end

  private

  def assignments
    @assignments ||= shift.assignments.where(physician_id: physician_id).in_date_range(start_date, end_date).all
  end

  def log_event(action)
    self.events = [] if events.empty?
    self.events << { action: action, timestamp: Time.now }
  end

  def dates_ordered
    unless end_date >= start_date && end_date >= meeting_start_date
      errors.add(:end_date, "must occur on or after the start date")
    end
    unless meeting_end_date >= meeting_start_date && meeting_end_date >= start_date
      errors.add(:meeting_end_date, "must occur on or after the start date")
    end
  end

  def dates_within_accepted_window
    schedule.meeting_request_date_errors(start_date).each { |e| errors.add(:start_date, e) }
    schedule.meeting_request_date_errors(end_date).each { |e| errors.add(:end_date, e) }
  end
end
