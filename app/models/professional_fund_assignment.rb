class ProfessionalFundAssignment < ActiveRecord::Base
  belongs_to :meeting_request, polymorphic: true
  belongs_to :professional_fund, :inverse_of => :professional_fund_assignments

  validates :professional_fund, :presence => true

  delegate :title, :requires_description, :to => :professional_fund, :prefix => false
end
