class ScheduleShift < ActiveRecord::Base
  DEFAULT_DISPLAY_COLOR = '#333'

  belongs_to :schedule
  belongs_to :shift, touch: true
  #belongs_to :call_shift, foreign_key: :shift_id, touch: true
  belongs_to :vacation_shift, foreign_key: :shift_id, touch: true
  #belongs_to :cme_meeting_shift, foreign_key: :shift_id, touch: true

  validates :schedule, :position, presence: true
  validates_associated :schedule, :shift
  validates :display_color, format: { with: %r{\A#[0-9a-f]{3,6}\z}i },
    allow_nil: true
  validates :hide_from_aggregate, inclusion: { in: [true, false] }

  default_scope -> { order("schedule_shifts.position") }
  scope :active_as_of, ->(cutoff_date) {
    where(["schedule_shifts.retired_on is null or schedule_shifts.retired_on > ?", cutoff_date])
  }
  scope :retired_as_of, ->(cutoff_date) {
    where(["schedule_shifts.retired_on <= ?", cutoff_date])
  }

  after_initialize :populate_defaults

  attr_reader :retire

  def retire=(value)
    if value.to_i == 1 && retired_on.nil?
      self[:retired_on] = Date.today
    elsif value.to_i == 0
      self[:retired_on] = nil
    end
  end

  private

  def populate_defaults
    self.display_color = DEFAULT_DISPLAY_COLOR unless display_color?
  end
end
