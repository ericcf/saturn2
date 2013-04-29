# Designates a User as a Schedule administrator.
class AdminAssignment < ActiveRecord::Base
  belongs_to :user, touch: true
  belongs_to :schedule

  validates :user, :schedule, :is_vacation_request_subscriber, presence: true
  validates_uniqueness_of :schedule_id, scope: :user_id
  validates :is_vacation_request_subscriber, inclusion: { in: [true, false] }
end
