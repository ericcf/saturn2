class Rotation < ActiveRecord::Base
  has_many :assignments, class_name: "RotationAssignment", dependent: :destroy, inverse_of: :rotation
  has_many :schedule_rotations, dependent: :destroy

  validates :title, presence: true, length: { maximum: 255 }
  validates :active_on, :retired_on, presence: true
  validate :retired_after_active

  private

  def retired_after_active
    unless retired_on > active_on
      errors.add(:retired_on, "must be later than active date")
    end
  end
end
