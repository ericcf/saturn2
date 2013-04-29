class CreatePublishedShiftWeeksView < ActiveRecord::Migration
  def up
    # Create a view for the PublishedShiftWeek model.
    # Consists of a shift_id, an array of included dates, and an array of schedule_ids.
    execute <<-SQL
      create or replace view published_shift_weeks as
      select ss.shift_id,
             array[wc.date, wc.date+1, wc.date+2, wc.date+3, wc.date+4, wc.date+5, wc.date+6] as dates,
             array_agg(s.id) as schedule_ids
      from schedules s
      join (
        select * from schedule_shifts
        join shifts on shifts.id = schedule_shifts.shift_id
      ) ss on (ss.schedule_id = s.id)
      join weekly_calendars wc on (wc.schedule_id = s.id)
      where (wc.is_published = 't'
            or ss.show_unpublished = 't')
            and (ss.retired_on is null or ss.retired_on > wc.date)
      group by ss.shift_id, wc.date
    SQL
  end

  def down
    execute "drop view published_shift_weeks"
  end
end
