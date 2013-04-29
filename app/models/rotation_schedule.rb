# A yearly schedule that begins on the same date each year.
class RotationSchedule < ActiveRecord::Base
  validates :start_date, :end_date,
            format:     { with: /\A\d{4}-[01]\d-[0-3]\d\z/ },
            uniqueness: true,
            presence:   true
  validates :is_published,
            inclusion: { in: [true, false] }

  has_many :rotation_assignments, dependent: :destroy
end
