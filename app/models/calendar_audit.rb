# Records actions made to a Weekly Calendar.
class CalendarAudit < ActiveRecord::Base
  serialize :log

  belongs_to :schedule

  validates :schedule, :date, :log, presence: true

  PUBLISHED = "published"
  UNPUBLISHED = "unpublished"
  SAVED = "saved"

  delegate :title, to: :schedule, prefix: true

  def self.recently_updated
    where("updated_at > ?", Time.now - 1.day)
  end

  def self.upcoming
    where("date > ?", Date.today - 1.week)
  end

  def append_to_log(user_name, action)
    self.log = [] if self.log.blank?
    self.log << { user: user_name, action: action, timestamp: Time.now }
  end
end
