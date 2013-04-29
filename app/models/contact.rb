class Contact < ActiveRecord::Base
  # dragonfly
  #image_accessor :photo
  
  include ActionView::Helpers::NumberHelper
  include ApplicationHelper

  with_options :dependent => :destroy do |assoc|
    assoc.has_one :address
    #assoc.has_many :group_memberships
    #assoc.has_many :section_memberships
  end
  has_many :groups, :through => :group_memberships
  has_many :sections, :through => :section_memberships

  accepts_nested_attributes_for :address, :reject_if => :all_blank

  before_validation :normalize_phone_attributes

  scope :non_guests, -> {
    where("contacts.type <> 'Guest'")
  }

  scope :current, -> {
    where("(contacts.employment_starts_on is null or contacts.employment_starts_on <= ?) and (contacts.employment_ends_on is null or contacts.employment_ends_on >= ?)", Date.today, Date.today)
  }

  def self.search(field, term)
    unless term.blank?
      sql_term = "%#{term}%"
      case field
      when "name"
        where "given_name like ? or other_given_names like ? or family_name like ?", sql_term, sql_term, sql_term
      when "email"
        where "email like ?", sql_term
      when "phone", "fax", "pager", "alpha_pager"
        where "#{field} like ?", sql_term
      end
    else
      all
    end
  end

  def self.by_last_initial(initial)
    unless initial.blank?
      where("family_name like ?", "#{initial}%")
    else
      all
    end
  end

  def self.by_groups(group_ids)
    unless group_ids.blank?
      joins(:group_memberships).where("group_memberships.group_id in (?)", group_ids)
    else
      all
    end
  end

  def self.by_sections(section_ids)
    unless section_ids.blank?
      joins(:section_memberships).where("section_memberships.section_id in (?)", section_ids)
    else
      all
    end
  end

  def self.by_types(types)
    unless types.blank?
      where :type => types
    else
      all
    end
  end

  def name
    [given_name, other_given_names, family_name].compact.join " "
  end

  def full_name(*options)
    return given_name if family_name.blank?
    if options.include? :given_first
      [given_name, other_given_names, family_name].compact.join " "
    else
      "#{family_name}, #{given_name}"
    end
  end

  #def as_json(options = {})
  #  super({
  #    :only => [:id, :family_name, :given_name, :email, :employment_starts_on, :type],
  #    :include => { :groups => { :only => [:id, :title] } }
  #  }.merge(options))
  #end

  private

  def normalize_phone_attributes
    %w[ phone fax pager alpha_pager ].each do |attr|
      value = self.send(attr)
      #self.send("#{attr}=", value.gsub(/[^\d]/, "")) if value.respond_to?(:gsub)
      self.send("#{attr}=", number_to_phone(value)) unless value.blank?
    end
  end
end
