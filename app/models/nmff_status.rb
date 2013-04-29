require 'saturn/fy_calc'
require 'vacation_calc'

class NmffStatus < ActiveRecord::Base
  FLOAT_DAYS_PER_Y = 1.0
  MAX_CARRYOVER_IN_DAYS = [
    { at_least_years: -500, up_to_years: 10, max_carryover: 10.0 },
    { at_least_years: 10, up_to_years: 25, max_carryover: 12.5 },
    { at_least_years: 25, up_to_years: 500, max_carryover: 15 }
  ]
  MAX_BALANCE_IN_DAYS = [
    { at_least_years: -500, up_to_years: 10, max_balance: 30.0 },
    { at_least_years: 10, up_to_years: 25, max_balance: 37.5 },
    { at_least_years: 25, up_to_years: 500, max_balance: 45 }
  ]

  attr_writer :vacation_carryover

  belongs_to :person

  validates :person, :hire_date, :fte, presence: true
  validates_numericality_of :fte, greater_than_or_equal_to: 0.0, less_than_or_equal_to: 1.0
  validates :person_id, uniqueness: true

  serialize :carryover

  after_initialize :set_hire_date
  before_validation :normalize_vacation_carryover

  def quarterly_allotted_days(fy, quarter)
    days = if (years = years_of_service(fy, quarter)) <= 0.0
      # the hire date is after the start of the quarter
      if (days_employed = Saturn::FYCalc.next_quarter_start_date(fy, quarter) - hire_date) > 0
        prorated = true
        with_float = true
        allotted = VacationCalc.allotted_days_per_q(0)
        # the hire date is within the quarter
        gross = days_employed / Saturn::FYCalc.quarter_length(fy, quarter) * allotted

        gross
      else
        # the hire date is after the end of the quarter
        allotted = 0.0
      end
    else
      # the hire date was before the start of the quarter
      allotted = VacationCalc.allotted_days_per_q(years)
      if quarter == 1
        with_float = true
        allotted
      else
        allotted
      end
    end

    {
      count: days * fte + (with_float ? FLOAT_DAYS_PER_Y : 0.0),
      explain: (prorated || with_float) && "#{allotted}#{fte < 1.0 ? " x #{fte}" : ''}#{prorated && ' (prorated)'}#{with_float && ' + 1.0 (float)'}"
    }
  end

  def vacation_carryover(fy = nil)
    fy ||= Saturn::FYCalc.fy_for_date(Date.today)
    (carryover || {})[fy].to_f
  end

  # Returns the maximum number of hours that can be carried over into the next fiscal year.
  def max_carryover_hours(fy)
    max_carryover_days(fy) * VacationCalc::HOURS_PER_DAY
  end

  def max_carryover_days(fy)
    service_years = years_of_service(fy + 1, 1)
    MAX_CARRYOVER_IN_DAYS.find { |b|
      b[:up_to_years] > service_years && b[:at_least_years] <= service_years
    }[:max_carryover]
  end

  def max_balance_hours(fy)
    max_balance_days(fy) * VacationCalc::HOURS_PER_DAY
  end

  def max_balance_days(fy)
    service_years = years_of_service(fy + 1, 1)
    MAX_BALANCE_IN_DAYS.find { |b|
      b[:up_to_years] > service_years && b[:at_least_years] <= service_years
    }[:max_balance]
  end

  private

  def normalize_vacation_carryover
    self.carryover ||= {}
    return unless @vacation_carryover
    @vacation_carryover.each do |fy, c|
      self.carryover[fy.to_i] = c.to_f
    end
  end

  def set_hire_date
    self.hire_date ||= Date.today
  end

  # Returns the number of years of service, counting from the start of the quarter.
  # If the hire date occurs after the start of the quarter, it returns a negative number.
  def years_of_service(fy, quarter)
    (Saturn::FYCalc.quarter_start_date(fy, quarter) - hire_date) / 365.0
  end

  def full_quarterly_allotted_hours(fy, quarter)
  end
end
