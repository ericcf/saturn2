class Resident < Person
  def name(*options)
    if options.include? :short
      "#{given_name[0]} #{family_name}"
    else
      "#{given_name} #{family_name}"
    end + (options.include?(:pgy) ? " P#{pgy}" : "")
  end

  def pgy(date=nil)
    (date || Date.today).year - employment_starts_on.year + 1
  end
end
