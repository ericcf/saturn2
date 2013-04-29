require 'saturn/has_human_name'

class GuestMembership < ActiveRecord::Base
  include ::Serializer::GuestMembership
  include Saturn::HasHumanName

  belongs_to :schedule
  has_many :guest_assignments, dependent: :destroy

  validates :schedule, :family_name, :given_name, presence: true

  default_scope -> { order(:family_name) }

  def type
    "Guest"
  end
end
