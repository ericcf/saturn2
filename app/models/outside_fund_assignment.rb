class OutsideFundAssignment < ActiveRecord::Base
  belongs_to :meeting_request, polymorphic: true
  belongs_to :outside_source_fund, :inverse_of => :outside_fund_assignments

  validates :outside_source_fund, :presence => true

  delegate :title, :requires_description, :to => :outside_source_fund, :prefix => false
end
