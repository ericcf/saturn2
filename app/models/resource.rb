class Resource < Contact
  validates :given_name, :presence => true

  with_options :dependent => :destroy do |assoc|
    assoc.has_many :group_memberships, :foreign_key => :contact_id
    assoc.has_many :section_memberships, :foreign_key => :contact_id
  end
  has_many :groups, :through => :group_memberships
  has_many :sections, :through => :section_memberships
end
