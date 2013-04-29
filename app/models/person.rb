require 'saturn/has_human_name'

class Person < ActiveRecord::Base
  self.table_name = 'contacts'
  include Saturn::HasHumanName

  TYPES = %W[ FacultyMember Fellow Resident StaffMember ]

  default_scope -> { where(type: TYPES) }

  has_many :schedule_memberships
  has_many :schedules, through: :schedule_memberships
  has_many :assignments
  has_many :deleted_assignments
  has_many :rotation_assignments
  has_one :nmff_status

  def self.current
    where("employment_ends_on is null or employment_ends_on > ?", Date.today)
  end

  def in_group?(group)
    type == group
  end
end
