# A view-backed model that pulls a record for each shift and week-start-date
# pair that is either published, or meant to be visible when unpublished.
class PublishedShiftWeek < ActiveRecord::Base
  # Does not work for shared shifts when the requested schedule doesn't share
  # a weekly calendar for specific weeks.
  scope :by_schedule, ->(schedule) { where("? = any(published_shift_weeks.schedule_ids)", schedule.id) }
end
