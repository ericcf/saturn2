class DayNote < ActiveRecord::Base
  belongs_to :schedule

  validates :schedule, :date, presence: true
  validates_uniqueness_of :date, scope: :schedule_id
end
