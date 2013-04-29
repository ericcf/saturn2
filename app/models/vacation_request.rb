class VacationRequest < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :requester, class_name: 'User'
  belongs_to :shift
  belongs_to :person

  validates :schedule, :requester, :person, :shift, :status, :start_date, :end_date, :events,
    presence: true
  validates :status, inclusion: { in: RequestWorkflow::STATES }
  validate :dates_within_accepted_window, on: :create
  validate :no_overlap_with_other_pending_requests, on: :create
  validate :no_overlap_with_assigned_vacation, on: :create

  serialize :events, Array

  delegate :short_name, :email, :to => :person, :prefix => true

  def self.in_date_range(start_date, end_date)
    where("vacation_requests.end_date >= ? and vacation_requests.start_date <= ?", start_date, end_date)
  end

  def self.upcoming
    where("end_date >= ?", Date.today)
  end

  def self.pending
    where(status: ['requested', 'cancellation requested'])
  end

  def log_event(action)
    self.events = [] if self.events.empty?
    self.events << { action: action, timestamp: Time.now }
  end

  def destroyed_assignments
    (start_date..end_date).map { |d| "#{self.class.to_s}#{id}_#{d}" }
  end

  def create_assignments
    (start_date..end_date).each do |date|
      Assignment.create(person_id: person_id, date: date, shift_id: shift_id)
    end
  end

  def destroy_assignments
    assignments.each { |a| a.destroy }
  end

  private

  def dates_ordered
    unless end_date >= start_date
      errors.add(:end_date, "must occur on or after the start date")
    end
  end

  def dates_within_accepted_window
    schedule.vacation_request_date_errors(start_date).each { |e| errors.add(:start_date, e) }
    schedule.vacation_request_date_errors(end_date).each { |e| errors.add(:end_date, e) }
  end

  def no_overlap_with_other_pending_requests
    if schedule.vacation_requests.
       where(person_id: person_id, shift_id: shift_id).
       pending.
       exists?(["id <> ? AND start_date <= ? AND end_date >= ?", (id || -1), end_date, start_date])
      errors.add(:base, 'dates cannot overlap an existing request')
    end
  end

  def no_overlap_with_assigned_vacation
    if schedule.member_assignments.includes(:shift).
       in_date_range(start_date, end_date).
       merge(schedule.vacation_shifts).
       exists?(person_id: person_id)
      errors.add(:base, 'dates cannot overlap existing vacation')
    end
  end

  def assignments
    @assignments ||= Assignment.where(person_id: person_id, shift_id: shift_id).in_date_range(start_date, end_date).all
  end
end
