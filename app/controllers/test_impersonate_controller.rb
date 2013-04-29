class TestImpersonateController < ApplicationController
  def impersonate
    session[:user_id] = params[:user_id]
    redirect_to root_url
  end
end
