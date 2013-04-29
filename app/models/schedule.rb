class Schedule < ActiveRecord::Base

  #SCHEDULE_GROUPS = %w[FacultyMember Fellow Resident]

  has_many :people, through: :memberships
  has_many :faculty_members, through: :memberships
  with_options dependent: :destroy do |assoc|
    assoc.has_many :memberships,
                   class_name: "ScheduleMembership"
    assoc.has_many :guest_memberships
    assoc.has_many :weekly_calendars
    assoc.has_many :schedule_shifts
    assoc.has_one  :weekly_shift_duration_rule
    assoc.has_many :admin_assignments
    assoc.has_many :day_notes
    assoc.has_many :schedule_rotations
    assoc.has_many :vacation_requests
  #  assoc.has_many :cme_meeting_requests
    assoc.has_many :events
  #  assoc.has_many :shift_groups
  end
  with_options through: :schedule_shifts do |assoc|
    assoc.has_many :shifts
  #  assoc.has_many :call_shifts
    assoc.has_many :vacation_shifts
  #  assoc.has_many :cme_meeting_shifts
  end
  has_many :administrators,
           through: :admin_assignments,
           source: :user
  #has_many :resident_rotations,
  #         through: :schedule_rotations,
  #         source: :rotation
  #has_many :resident_assignments,
  #         through: :resident_rotations,
  #         source: :assignments
  #accepts_nested_attributes_for :shifts
  #accepts_nested_attributes_for :call_shifts
  #accepts_nested_attributes_for :vacation_shifts
  #accepts_nested_attributes_for :schedule_shifts
  #accepts_nested_attributes_for :weekly_shift_duration_rule

  validates :title,
    presence: true,
    uniqueness: true,
    length: { maximum: 255 }
  validates :accept_vacation_requests, :open_reports,
    inclusion: { in: [true, false] }
  validates :vacation_request_max_days_advance, :vacation_request_min_days_advance,
    numericality: { greater_than_or_equal_to: 0, less_than: 4000 }
  validates_numericality_of :vacation_request_min_days_advance,
    less_than_or_equal_to: Proc.new { |schedule| schedule.vacation_request_max_days_advance }

  #def self.find_by_slug_or_id(value)
  #  where("slug = ? or id = ?", value, value.to_i).first
  #end

  #def allowed_shift_overlaps
  #  AllowedShiftOverlap.where(shift_a_id: shifts)
  #end

  #def find_shift(shift_id)
  #  shifts.find(shift_id)
  #end

  #def to_s
  #  title
  #end

  # Returns scoped assignments (published and unpublished).
  def assignments
    @assignments ||= Assignment.includes(:shift).merge(Shift.includes(:schedule_shifts).merge(ScheduleShift.unscoped.where(schedule_id: id)))
  end

  # Returns scoped member assignments (published and unpublished).
  def member_assignments
    assignments.where(person_id: member_ids)
  end

  #def published_assignments
  #  Assignment.published.merge(PublishedShiftWeek.by_schedule(self))
  #end

  #def guest_assignments
  #  GuestAssignment.includes(:shift).
  #    where(shift_id: shifts.map(&:id), guest_membership_id: guest_membership_ids)
  #end

  ## Scoped shifts that are active as of today by default. Otherwise, shifts active as of the :as_of option.
  #def active_shifts(options = nil)
  #  date = options.nil? ? Date.today : options[:as_of]
  #  Shift.joins(:schedule_shifts).merge(schedule_shifts.active_as_of(date))
  #end

  ## Scoped shifts that are retired as of today by default. Otherwise, shifts retired as of the :as_of option.
  #def retired_shifts_as_of(date)
  #  Shift.joins(:schedule_shifts).merge(schedule_shifts.retired_as_of(date))
  #end

  def member_ids
    memberships.map(&:person_id)
  end

  #def is_member?(person_id)
  #  memberships.exists?(person_id: person_id)
  #end

  #def vacation_request_subscribers
  #  administrators.where("admin_assignments.is_vacation_request_subscriber = ?", true)
  #end

  #def cme_meeting_request_subscribers
  #  administrators
  #end

  # Returns an array of error messages.
  def vacation_request_date_errors(date, date_factory = Date)
    errors = []
    unless date >= date_factory.today + vacation_request_min_days_advance
      errors << "must be at least #{vacation_request_min_days_advance} days from now"
    end
    unless vacation_request_max_days_advance == 0 ||
           date <= date_factory.today + vacation_request_max_days_advance
      errors << "may be at most #{vacation_request_max_days_advance} days from now"
    end
    
    errors
  end

  ## Returns an array of error messages.
  #def meeting_request_date_errors(date, date_factory = Date)
  #  errors = []
  #  unless date >= date_factory.today + meeting_request_min_days_advance
  #    errors << "must be at least #{meeting_request_min_days_advance} days from now"
  #  end
  #  unless meeting_request_max_days_advance == 0 ||
  #         date <= date_factory.today + meeting_request_max_days_advance
  #    errors << "may be at most #{meeting_request_max_days_advance} days from now"
  #  end
  #  
  #  errors
  #end
end
