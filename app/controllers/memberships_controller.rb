class MembershipsController < ApplicationController
  include ScheduleResourceController
  include ControllerHelpers

  respond_to :json

  before_filter :authenticate_user!, :authorize_schedule_admin!

  def index
    @physicians = Physician.current
    @members = ScheduleMember.new_collection(@schedule.memberships.includes(:physician).order("physicians.family_name"))
    @guests = @schedule.guest_memberships.order(:family_name).as_json(only: [:id, :family_name, :given_name], methods: [])
  end

  def create
    membership = @schedule.memberships.build(params.slice(:physician_id))

    if membership.save
      create_associated_user(membership.physician)
      member = ScheduleMember.new(membership.physician, membership)
      render json: member, status: :created
    else
      render json: { error: "Unable to save the member: #{errors_on membership}." }, status: :bad_request
    end
  end

  def update
    membership = @schedule.memberships.find_by_physician_id(params[:id])

    if membership.update_attributes(params.slice(:initials, :fte))
      member = ScheduleMember.new(membership.physician, membership)
      render json: member
    else
      render json: { error: "Unable to save the member: #{errors_on membership}." }, status: :bad_request
    end
  end

  def destroy
    membership = @schedule.memberships.find_by_physician_id(params[:id])

    if membership.destroy
      member = ScheduleMember.new(membership.physician, membership)
      respond_with member
    else
      render json: { error: "Unable to remove the member: #{errors_on membership}." }, status: :bad_request
    end
  end

  private

  def create_associated_user(physician)
    unless User.exists?(physician_id: physician.id)
      email = physician.email || APP_CONFIG["from_email"]
      p = (1..8).map { ("a".."z").to_a[rand(26)] }.join
      User.create({ username:              "#{physician.given_name}#{physician.family_name}",
                    given_name:            physician.given_name,
                    family_name:           physician.family_name,
                    email:                 email,
                    physician_id:          physician.id,
                    password:              p,
                    password_confirmation: p },
                  as: :admin)
    end
  end
end
