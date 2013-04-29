class Shift < ActiveRecord::Base
  #include ::Serializer::Shift

  #DEFAULT_START_TIME = "07:00"
  #DEFAULT_END_TIME = "17:00"

  with_options dependent: :destroy do |assoc|
    assoc.has_many :schedule_shifts
    assoc.has_many :assignments
  #  assoc.has_many :deleted_assignments
    assoc.has_many :assignment_labels
    assoc.has_many :guest_assignments
  end
  has_many :schedules, through: :schedule_shifts
  accepts_nested_attributes_for :schedule_shifts, allow_destroy: true

  #serialize :recurrence

  validates :title, :starts_at, :ends_at, presence: true
  validates :show_unpublished, inclusion: { in: [true, false] }
  validates :title, :phone, length: { maximum: 255 }
  validates :type, inclusion: { in: ['CallShift', 'VacationShift', 'CmeMeetingShift'], allow_nil: true }
  #validate :single_cme_meeting_per_schedule

  #after_initialize :populate_defaults

  #before_validation { clean_text_attributes :title, :phone }
  #before_validation :filter_recurrence

  #def set_type(value)
  #  self.type = value.blank? ? nil : value
  #end

  #def display_color_for_schedule(schedule)
  #  schedule_shifts.where(schedule_id: schedule.id).select(:display_color).
  #    map(&:display_color).first
  #end

  def start_time
    starts_at.to_s(:meridian_time).strip
  end

  def end_time
    ends_at.to_s(:meridian_time).strip
  end

  #private

  #def populate_defaults
  #  self.starts_at = DEFAULT_START_TIME unless self.starts_at
  #  self.ends_at = DEFAULT_END_TIME unless self.ends_at
  #end

  #def filter_recurrence
  #  if recurrence.respond_to?(:select)
  #    self[:recurrence] = recurrence.select { |r| !r.blank? }
  #  end
  #end

  #def single_cme_meeting_per_schedule
  #  if self.type == "CmeMeetingShift"
  #    schedules.each do |s|
  #      if s.cme_meeting_shift_ids.select { |id| id != self.id }.size >= 1
  #        errors.add :type, 'Cannot have multiple CME Meeting shifts.'
  #      end
  #    end
  #  end
  #end
end
