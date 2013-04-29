class DashboardsController < ApplicationController
  def show
    if current_user
      render :user
    end
  end

  def user
    @dashboard = DashboardPresenter.new
  end

  def admin
  end
end
