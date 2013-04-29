require 'nurad_login/user'

class User
  with_options dependent: :destroy do |assoc|
    assoc.has_many :admin_assignments
  #  assoc.has_one :conference_schedule_user
  #  assoc.has_many :conferences, foreign_key: 'creator_id'
  end

  with_options dependent: :nullify do |a|
    a.has_many :assignments, foreign_key: 'editor_id'
    #a.has_many :deleted_assignments, foreign_key: 'editor_id'
  end

  has_many :admin_schedules,
    through: :admin_assignments,
    source: :schedule

  belongs_to :physician

  def self.schedule_admin
    joins(:admin_assignments).uniq
  end

  def self.generate_password
    choices = %w[ a b c d e f g h k m n p q r s u v w x y z A B C D E F G H K L M N P Q R S T U V W X Y 3 4 5 6 7 8 9 @ # $ % & * ( ) / = - ]

    p (1..8).map { choices[rand(choices.size)] }.join
  end

  def member_schedules
    physician.try(:schedules) || []
  end

  def display_name
    if !given_name.blank? || !family_name.blank?
      [given_name, family_name].compact.join " "
    else
      username
    end
  end

  def schedule_memberships=(attributes)
    attributes.each do |membership_id, attrs|
      ScheduleMembership.find(membership_id).update_attributes(attrs)
    end
  end
end
