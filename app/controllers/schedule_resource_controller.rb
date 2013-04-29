# To be included in schedule sub-resources.
module ScheduleResourceController

  extend ActiveSupport::Concern

  included do
    before_filter :find_schedule
    layout 'schedule'
    helper_method :is_schedule_admin?, :is_schedule_member?
  end

  private

  def authorize_schedule_admin!
    authorize! :manage, @schedule
  end

  def find_schedule
    schedule_id = params[:schedule_id]
    return(redirect_to(schedules_url)) unless schedule_id
    @schedule = Schedule.find_by_slug_or_id(schedule_id)
  end

  def is_schedule_admin?
    session[:current_role] != 'member' && can?(:manage, @schedule)
  end

  def is_schedule_member?
    current_user && @schedule.is_member?(current_user.physician_id)
  end
end
