class AllowedShiftOverlap < ActiveRecord::Base
  belongs_to :shift_a, class_name: 'Shift'
  belongs_to :shift_b, class_name: 'Shift'

  validates :shift_a, :shift_b, presence: true
  validates_uniqueness_of :shift_b_id, scope: :shift_a_id
end
