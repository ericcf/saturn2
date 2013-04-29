class WeeklyCalendarsController < ApplicationController
  include ScheduleResourceController
  include ControllerHelpers

  respond_to :html, :xls, only: :index
  respond_to :json, only: [:show, :update]

  before_filter :authenticate_user!, :authorize_schedule_admin!,
                only: :update
  before_filter :calculate_date, except: :update

  def index
    return redirect_to(root_url, flash: { error: 'Unable to find schedule.' }) unless @schedule
    respond_to do |format|
      format.html do
        @shifts = @schedule.active_shifts.includes(:schedule_shifts).to_json
        @rotations = Rotation.all.to_json(only: [:id, :title])
        # memberships param required to include FTE
        @physicians = (ScheduleMember.new_collection(@schedule.memberships.includes(:physician).order("physicians.family_name")) + @schedule.guest_memberships.order(:family_name)).
          to_json(memberships: @schedule.memberships)
        @user_role = if is_schedule_admin?
                       'admin'
                     elsif is_schedule_member?
                       'member'
                     else
                       'visitor'
                     end
        @allowed_overlap_shifts = @schedule.allowed_shift_overlaps.map { |o| [o.shift_a_id, o.shift_b_id] }
      end

      format.xls do
        @schedule_presenter = Logical::SchedulePresenter.new(dates: (@date..@date+6).to_a,
                                                             schedule: @schedule,
                                                             show_unpublished: is_schedule_admin?)
      end
    end
  end

  # unauthenticated!
  def show
    # It is a bit inefficient to find_or_create versus find_or_initialize,
    # but it greatly simplifies queries on unpublished calendars.
    respond_with @schedule.weekly_calendars.find_or_create_by_date(@date)
  end

  def update
    @schedule = @schedule.weekly_calendars.find(params[:id])

    if @schedule.update_attributes(sanitized_params)
      save_audit
      render json: @schedule
    else
      render json: { error: "unable to update schedule: #{errors_on @schedule}" },
             status: 400
    end
  end

  private

  def calculate_date
    @date = (params[:date] ? Date.parse(params[:date]) : Date.today).
      at_beginning_of_week
  end

  def sanitized_params
    (params || {}).slice(:is_published)
  end

  def save_audit
    audit = CalendarAudit.where(date: schedule.date, schedule_id: schedule.schedule_id).first ||
      CalendarAudit.new(date: schedule.date, schedule_id: schedule.schedule_id)
    action = if schedule.is_published_changed?
               schedule.is_published? ? CalendarAudit::PUBLISHED : CalendarAudit::UNPUBLISHED
             else
               CalendarAudit::SAVED
             end
    audit.append_to_log User.current.display_name, action
    audit.save
  end
end
