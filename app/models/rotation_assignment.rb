class RotationAssignment < ActiveRecord::Base
  belongs_to :rotation, inverse_of: :assignments
  belongs_to :rotation_schedule
  belongs_to :person, class_name: 'Resident'

  validates :person, :rotation, :rotation_schedule, :starts_on, :ends_on, presence: true
  validate :ends_on_not_before_starts_on?
  validate :no_overlap

  delegate :title, to: :rotation, prefix: true

  scope :include_date, ->(date) {
    where("rotation_assignments.ends_on >= ? and rotation_assignments.starts_on <= ?", date, date)
  }

  scope :in_date_range, ->(start_date, end_date) {
    where("rotation_assignments.ends_on >= ? AND rotation_assignments.starts_on <= ?", start_date, end_date)
  }

  scope :in_year_beginning, ->(date) {
    end_date = Date.parse(date) + 1.year - 1.day
    where("rotation_assignments.ends_on >= ? and rotation_assignments.starts_on <= ?", date, end_date)
  }

  scope :published, -> { includes(:rotation_schedule).where("rotation_schedules.is_published = ?", true) }

  default_scope -> { where(is_deleted: false) }

  def physician_name(*options)
    Resident.all.find{ |r| r.id == person_id }.name *options
  end

  def serializable
    {
      id: id,
      physician_name: physician_name(:short, :pgy),
      rotation_title: rotation_title
    }
  end

  private

  def ends_on_not_before_starts_on?
    if self[:starts_on] && self[:ends_on]
      unless self[:ends_on] >= self[:starts_on]
        errors.add(:ends_on, "cannot occur before the start")
      end
    end
  end

  def no_overlap
    if self[:starts_on] && self[:ends_on]
      overlaps = RotationAssignment.where("id <> ?", self.id || -1)
        .where(person_id: self[:person_id])
        .where("ends_on > ? and starts_on < ?", self[:starts_on], self[:ends_on])
      if overlaps.size != 0
        errors.add(:base, "cannot overlap another assignment")
      end
    end
  end
end
