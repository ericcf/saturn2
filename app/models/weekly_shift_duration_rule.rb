class WeeklyShiftDurationRule < ActiveRecord::Base

  belongs_to :schedule

  validates :schedule, presence: true
  validates_associated :schedule
  validates :minimum, :maximum, numericality: {
    greater_than_or_equal_to: 0.0,
    less_than_or_equal_to: 999.9,
    allow_nil: true
  }
  validate :maximum_greater_than_or_equal_to_minimum?

  private

  def maximum_greater_than_or_equal_to_minimum?
    unless self[:maximum].nil? or self[:minimum].nil?
      unless self[:maximum] >= self[:minimum]
        errors.add(:maximum, "must be greater than the minimum")
      end
    end
  end
end
