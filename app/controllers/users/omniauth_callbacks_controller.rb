class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_authorize_resource
  before_action :find_user_with_google_data, only: :google_oauth2

  def google_oauth2
    flash[:notice] = "signed in successfully"
    sign_in_and_redirect @user
  end

  private
    def find_user_with_google_data
      @user = User.find_for_google_oauth2(request.env["omniauth.auth"], current_user)
      redirect_to root_url, :alert => "You are not authorize to login" unless @user
    end
end