class AssignmentLabel < ActiveRecord::Base
  belongs_to :shift
  has_many :assignments, foreign_key: :label_id, dependent: :nullify
  has_many :deleted_assignments, foreign_key: :label_id, dependent: :nullify

  validates :text, :shift, presence: true
  validates_uniqueness_of :text, scope: :shift_id, case_sensitive: false

  scope :like, ->(text) { where("assignment_labels.text like ?", text) }

  def self.search(text)
    if text.blank?
      scoped
    else
      where("assignment_labels.text like ?", "%#{text}%")
    end
  end

  def self.find_or_create_like(shift_id, text)
    return if text.blank?
    fixed = text.try(:strip)

    where(shift_id: shift_id).like(fixed).first ||
      create(shift_id: shift_id, text: fixed)
  end

  def destroy_if_orphaned!
    destroy if orphaned?
  end

  private

  def orphaned?
    assignments.count == 0
  end
end
