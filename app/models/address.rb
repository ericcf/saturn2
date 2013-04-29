class Address < ActiveRecord::Base
  STATES = YAML.load_file(File.expand_path 'lib/states.yml', Rails.root)

  belongs_to :contact

  validates :street, :city, :state, :zip, presence: true
  validates :contact_id, uniqueness: true
end
