class VacationCalc
  HOURS_PER_DAY = 8.0

  def self.vacation_hours_per_q
    @@vacation_hours_per_q ||= APP_CONFIG["vacation_hours_per_q"]
  end

  def self.vacation_hours_per_q=(value)
    @@vacation_hours_per_q = value
  end

  def self.allotted_hours_per_q(years_of_service)
    vacation_hours_per_q.find do |hours, range|
      range[0] <= years_of_service && range[1] > years_of_service
    end.first
  end

  def self.allotted_days_per_q(years_of_service)
    allotted_hours_per_q(years_of_service) / HOURS_PER_DAY
  end
end
