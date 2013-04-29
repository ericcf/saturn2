class DeletedAssignment < ActiveRecord::Base
  belongs_to :shift
  belongs_to :physician
  belongs_to :label, class_name: "AssignmentLabel"
  belongs_to :editor, class_name: "User"
  has_many :published_shift_weeks,
    foreign_key: "shift_id",
    primary_key: "shift_id"
  has_many :schedule_memberships,
    foreign_key: "physician_id",
    primary_key: "physician_id"

  def self.create_from(assignment, editor_id)
    attributes = assignment.attributes.slice('shift_id', 'physician_id', 'date', 'public_note', 'private_note', 'duration', 'starts_at', 'ends_at', 'label_id')
    new(attributes).tap do |a|
      a.editor_id = editor_id
      a.original_created_at = assignment.created_at
    end.save
  end

  def self.published
    joins(:published_shift_weeks, :schedule_memberships).
    where("deleted_assignments.date = any(published_shift_weeks.dates) and schedule_memberships.schedule_id = any(published_shift_weeks.schedule_ids)").
    uniq
  end

  def self.recently_updated
    where("updated_at > ?", Time.now - 1.day)
  end

  def self.upcoming
    where("date > ?", Date.today - 1.week)
  end
end
