class ScheduleMembership < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :person
  belongs_to :faculty_member, foreign_key: 'person_id'

  validates :person, :schedule, :fte, presence: true
  validates_uniqueness_of :person_id, scope: :schedule_id
  validates :fte, numericality: { greater_than: 0, less_than_or_equal_to: 1 }

  before_save :check_initials

  delegate :title, to: :schedule, prefix: true

  private

  def check_initials
    if initials.blank?
      self.initials = nil
    end
  end
end
