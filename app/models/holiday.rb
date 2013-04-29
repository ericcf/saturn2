class Holiday < ActiveRecord::Base
  validates :date, :title, presence: true
  validates :title, length: { maximum: 255 }

  def to_s
    title
  end
end
