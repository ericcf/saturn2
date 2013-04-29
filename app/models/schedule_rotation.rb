class ScheduleRotation < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :rotation

  validates :schedule, :rotation, presence: true
  validates_uniqueness_of :rotation_id, scope: :schedule_id
end
