class PeopleController < ApplicationController
  def index
    # only select those people who are attached to schedules
    @memberships = ScheduleMembership.includes(:schedule).inject({}) do |h, m|
      h[m.person_id] ||= []
      h[m.person_id] << m.schedule_title
      h
    end
    @people = Person.where(id: @memberships.keys.uniq).order(:family_name)
  end
end
