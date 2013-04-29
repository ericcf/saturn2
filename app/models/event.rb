class Event < ActiveRecord::Base

  belongs_to :schedule

  validates :title, :schedule, :start_date, :end_date, presence: true
  validate :end_not_before_start

  def self.in_year(year)
    first = Date.parse("#{year}-01-01")
    last = Date.parse("#{year}-12-31")
    where('events.start_date <= ? AND events.end_date >= ?', last, first)
  end

  class EventInstance
    attr_reader :title, :date

    def initialize(attrs)
      @title, @date = attrs[:title], attrs[:date]
    end
  end

  # Assumes +dates+ are consecutive.
  def self.instances_on(dates)
    where('events.start_date <= ? AND events.end_date >= ?', dates.last, dates.first).map do |e|
      (e.start_date..e.end_date).map do |d|
        EventInstance.new(title: e.title, date: d)
      end
    end.flatten
  end

  private

  def end_not_before_start
    if end_date && start_date
      unless end_date >= start_date
        errors.add(:end_date, 'must occur on or after the start date')
      end
    end
  end
end
