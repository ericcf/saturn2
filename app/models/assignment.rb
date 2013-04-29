class Assignment < ActiveRecord::Base
  include ::Serializer::Assignment

  MERIDIAN_TIME_EXPRESSION = /(\d{1,2})\s*:\s*(\d\d)\s*(am|pm)/i

  attr_writer :start_time, :end_time

  belongs_to :shift
  belongs_to :person
  has_many :schedule_shifts, through: :shift
  has_many :schedules, through: :schedule_shifts
  has_many :weekly_calendars, through: :schedules
  has_many :published_shift_weeks,
    foreign_key: "shift_id",
    primary_key: "shift_id"
  has_many :schedule_memberships,
    foreign_key: "person_id",
    primary_key: "person_id"
  belongs_to :label, class_name: "AssignmentLabel"
  belongs_to :editor, class_name: "User"

  validates :shift, :person, :date, presence: true
  validates_associated :shift
  validates_uniqueness_of :person_id,
    scope: [:shift_id, :date],
    message: "cannot be given a duplicate assignment"
  validates :private_note, :public_note, length: { maximum: 255 }
  validate :start_and_end_times_formatted?

  after_validation :propagate_start_and_end_times

  scope :in_date_range, ->(start_date, end_date) {
    where("assignments.date >= ? and assignments.date <= ?", start_date, end_date)
  }

  scope :published, -> {
    joins(:published_shift_weeks, :schedule_memberships).
    where("assignments.date = any(published_shift_weeks.dates) and schedule_memberships.schedule_id = any(published_shift_weeks.schedule_ids)").
    uniq
  }

  delegate :title, to: :shift, prefix: true
  delegate :display_color_for_schedule, to: :shift, prefix: true
  delegate :display_name, to: :editor, prefix: true, allow_nil: true

  def self.recently_updated
    where("updated_at > ?", Time.now - 1.day)
  end

  def self.upcoming
    where("date > ?", Date.today - 1.week)
  end

  # Create multiple assignments for a single schedule and shift.
  # expects :shift_ids, :person_ids, :dates
  # If any assignments cannot be created, all will be rolled back
  # and an ActiveRecord::RecordInvalid exception will be raised.
  def self.batch_create!(params)
    person_ids = Person::TYPES.map do |group|
      params["#{group.underscore}_ids".to_sym] || []
    end.reduce(:+)
    missing_params = []
    missing_params << "dates" unless params[:dates].is_a?(Array)
    missing_params << "shifts" unless params[:shift_ids].is_a?(Array)
    if missing_params.size > 0
      raise ActiveRecord::ActiveRecordError,
        "missing #{missing_params.join ", "}"
    end
    assignments = []
    transaction do
      params[:dates].each do |date|
        person_ids.each do |person_id|
          params[:shift_ids].each do |shift_id|
            assignments << create!(shift_id:  shift_id,
                                   date:      date,
                                   person_id: person_id,
                                   editor_id: params[:user_id])
          end
        end
        (params[:guest_ids] || []).each do |guest_id|
          params[:shift_ids].each do |shift_id|
            assignments << GuestAssignment.create!(shift_id:            shift_id,
                                                   date:                date,
                                                   guest_membership_id: guest_id,
                                                   editor_id:           params[:user_id])
          end
        end
      end
    end

    assignments
  end

  def label_text=(value)
    self.label = AssignmentLabel.find_or_create_like(shift_id, value)
  end

  def label_text
    label.try :text
  end

  # Passed along in serialization for use by client.
  def person_type
    "Member"
  end

  def times_altered?
    start_time != shift.start_time || end_time != shift.end_time
  end

  def adjusted_duration
    duration || shift.duration
  end

  # A virtual attribute to use in lieu of starts_at.
  def start_time(*args)
    raw = starts_at || shift.starts_at
    raw = Time.local date.year, date.month, date.day, raw.hour, raw.min
    return raw if args.include? :raw
    raw.to_s(:meridian_time).strip
  end

  # A virtual attribute to use in lieu of ends_at.
  def end_time(*args)
    raw = ends_at || shift.ends_at
    # account for pm-am shift
    end_date = shift.ends_at < shift.starts_at ? date + 1 : date
    raw = Time.local end_date.year, end_date.month, end_date.day, raw.hour, raw.min
    return raw if args.include? :raw
    raw.to_s(:meridian_time).strip
  end

  private

  # Convert HH:MMxm to HH:MM.
  def twenty_four_hour_time(meridian_time)
    parts = meridian_time.match(MERIDIAN_TIME_EXPRESSION)
    return if parts.nil?
    hour = parts[1].to_i
    minute = parts[2]
    meridian = parts[3].downcase
    hour = hour + (hour != 12 && meridian == "pm" ? 12 : 0)

    "#{hour}:#{minute}"
  end

  def start_and_end_times_formatted?
    if @start_time && @start_time.match(MERIDIAN_TIME_EXPRESSION).nil?
      errors.add(:start_time, "must be formatted like '12:05am'")
    end
    if @end_time && @end_time.match(MERIDIAN_TIME_EXPRESSION).nil?
      errors.add(:end_time, "must be formatted like '12:05am'")
    end
  end

  # Convert and save the virtual attributes.
  def propagate_start_and_end_times
    if @start_time && @start_time != shift.start_time
      self.starts_at = twenty_four_hour_time(@start_time)
    else
      self.starts_at = nil
    end
    if @end_time && @end_time != shift.end_time
      self.ends_at = twenty_four_hour_time(@end_time)
    else
      self.ends_at = nil
    end
  end
end
