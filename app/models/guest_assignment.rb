class GuestAssignment < ActiveRecord::Base
  include ::Serializer::GuestAssignment

  belongs_to :shift
  belongs_to :guest_membership
  belongs_to :editor, class_name: "User"

  validates :shift, :guest_membership, :date, presence: true
  validates_uniqueness_of :guest_membership_id,
    scope: [:shift_id, :date],
    message: "cannot be given a duplicate assignment"

  scope :in_date_range, ->(start_date, end_date) {
    where("guest_assignments.date >= ? and guest_assignments.date <= ?", start_date, end_date)
  }

  delegate :display_name, to: :editor, prefix: true, allow_nil: true

  def physician_id
    guest_membership_id
  end

  def physician_type
    "Guest"
  end

  def start_time
    shift.start_time
  end

  def end_time
    shift.end_time
  end
end
