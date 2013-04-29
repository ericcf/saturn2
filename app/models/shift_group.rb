class ShiftGroup < ActiveRecord::Base
  belongs_to :schedule

  serialize :shift_ids

  before_validation :convert_shift_ids

  private

  def convert_shift_ids
    self[:shift_ids] = shift_ids.select { |id| id != "" }.map(&:to_i)
  end
end
