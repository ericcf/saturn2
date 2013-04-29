class WeeklyCalendar < ActiveRecord::Base
  #include ::Serializer::WeeklyCalendar

  belongs_to :schedule
  #has_many :shifts, through: :schedule

  validates_presence_of :schedule, :date
  validates_uniqueness_of :date, scope: :schedule_id

  # given an array of dates, return the calendars that contain those dates
  scope :include_dates, ->(dates) {
    possible_schedule_dates = dates.sort.map do |date|
      (date - 6..date).select { |d| d.wday == 1 }
    end.flatten.uniq
    where(date: possible_schedule_dates)
  }
  scope :by_year, ->(year) { where('extract(year from weekly_calendars.date) = ?', year) }
  scope :published, -> { where(is_published: true) }
  scope :by_schedules, ->(schedules_or_ids) { where(schedule_id: schedules_or_ids) }
  #default_scope order: "weekly_calendars.date"

  #def shifts
  #  schedule.active_shifts(as_of: date)
  #end

  #def assignments
  #  Assignment.where(date: dates,
  #    shift_id: shifts.map(&:id),
  #    physician_id: schedule.member_ids
  #  )
  #end

  #def read_only_assignments
  #  @read_only_assignments ||= assignments.select("date, duration, id, position, private_note, public_note, shift_id, physician_id, updated_at").includes(:shift)
  #end

  #def dates
  #  @dates ||= (date..date + 6.days).to_a
  #end

  #def events
  #  Holiday.where(date: dates).all + schedule.events.instances_on(dates)
  #end

  #def resident_assignments
  #  schedule.resident_assignments.include_date(dates.first).map { |a| a.serializable }
  #end

  #def holiday_titles_by_date
  #  @holiday_titles_by_date ||= events.each_with_object({}) do |holiday, hsh|
  #    hsh[holiday.date] = holiday.title
  #  end
  #end
end
