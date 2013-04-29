require 'saturn/fy_calc'

describe Saturn::FYCalc do
  describe ".fy_for_date" do
    it "returns the correct FY" do
      {
        :'2012-08-31'=> 2012,
        :'2012-09-01'=> 2013,
        :'2013-08-31'=> 2013,
        :'2013-09-01'=> 2014
      }.each do |date, fy|
        Saturn::FYCalc.fy_for_date(Date.parse(date.to_s)).should eq(fy)
      end
    end
  end

  describe ".fy_bound_dates" do
    it "returns the first and last dates of the FY" do
      dates = Saturn::FYCalc.fy_bound_dates(2013)
      dates[0].to_s.should eq('2012-09-01')
      dates[1].to_s.should eq('2013-08-31')
    end
  end

  describe ".next_quarter_start_date" do
    it "returns the first date of the following quarter" do
      Saturn::FYCalc.next_quarter_start_date(2013, 4).to_s.should eq('2013-09-01')
    end
  end

  describe ".month_dates_in_fy" do
    it "returns the first day of each month in the FY" do
      dates = Saturn::FYCalc.month_dates_in_fy(2012)
      dates.length.should eq(12)
      dates[0].to_s.should eq('2011-09-01')
      dates[-1].to_s.should eq('2012-08-01')
    end
  end

  describe ".quarter_length" do
    it "returns the length of the quarter in days" do
      Saturn::FYCalc.quarter_length(2013, 3).should eq(92)
    end
  end
end
