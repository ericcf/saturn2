require 'spec_helper'

describe ApplicationController do
  controller do
    def index
      raise CanCan::AccessDenied
    end
  end

  describe 'encountering CanCan::AccessDenied exceptions' do
    it 'redirects to /' do
      get :index
      expect(response).to redirect_to(root_url)
    end
  end
end
