class Guest < Contact
  validates :given_name, :family_name, :email, :presence => true
end
