require 'rubygems'
require 'active_support/core_ext/date/calculations' # allows Date.new(yyyy, mm, dd)
require 'active_support/core_ext/date/acts_like'    # allows date math
require 'active_support/core_ext/integer/time'      # allows x.months

module Saturn
  # Convenience/utility methods.
  class FYCalc
    QUARTERS = {
      1 => { year: -1, month: 9, day: 1 },
      2 => { year: -1, month: 12, day: 1 },
      3 => { year: 0, month: 3, day: 1 },
      4 => { year: 0, month: 6, day: 1 }
    }

    def self.fy_for_date(date)
      if date.month >= QUARTERS[1][:month]
        date.year + 1
      else
        date.year
      end
    end

    def self.fy_bound_dates(fy)
      [quarter_start_date(fy, 1), quarter_start_date(fy.to_i + 1, 1) - 1]
    end

    def self.quarter_start_date(fy, quarter)
      date = QUARTERS[quarter]
      Date.new(fy.to_i + date[:year], date[:month], date[:day])
    end

    def self.next_quarter_start_date(fy, quarter)
      quarter = quarter == 4 ? 1 : quarter + 1
      year = quarter == 1 ? fy.to_i + 1 : fy.to_i
      quarter_start_date(year, quarter)
    end

    def self.month_dates_in_fy(fy)
      (1..4).map { |q| month_dates_in_quarter(fy, q) }.flatten
    end

    def self.month_dates_in_quarter(fy, quarter)
      start_date = quarter_start_date(fy, quarter)
      (0..2).map do |offset|
        start_date + offset.months
      end
    end

    # length of the quarter in days
    def self.quarter_length(fy, quarter)
      next_quarter_start_date(fy, quarter) - quarter_start_date(fy, quarter)
    end
  end
end
