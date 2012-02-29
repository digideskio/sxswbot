class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def rdio
      @user = User.find_for_rdio_oauth(request.env["omniauth.auth"], current_user)
      puts request.env["omniauth.auth"].extra.access_token
      if @user.persisted?
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Rdio"
        sign_in_and_redirect @user, :event => :authentication
      else
        session["devise.rdio_data"] = request.env["omniauth.auth"]
        redirect_to new_user_registration_url
      end
    end
end