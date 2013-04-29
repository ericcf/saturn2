class StaffMember < Contact
  validates :given_name, :family_name, :email, presence: true

  with_options dependent: :destroy do |assoc|
    assoc.has_many :assistant_assists,
                   :foreign_key => :assistant_id,
                   :class_name => "Assist"
    assoc.has_many :manager_assists,
                   :foreign_key => :manager_id,
                   :class_name => "Assist"
    #assoc.has_many :group_memberships, :foreign_key => :contact_id
    #assoc.has_many :section_memberships, :foreign_key => :contact_id
  end
  has_many :managers, :through => :assistant_assists
  has_many :assistants, :through => :manager_assists
  #has_many :groups, :through => :group_memberships
  #has_many :sections, :through => :section_memberships
end
