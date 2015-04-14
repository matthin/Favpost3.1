class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    auth = env["omniauth.auth"]

    @user = User.find_for_twitter_oauth(request.env["omniauth.auth"],current_user)
    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.twitter_uid"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  # GET|POST /resource/auth/twitter
  # def passthru
  #   super
  # end

  # def after_sign_in_path_for(resource)
  #   new_user_registration_path(resource)
  # end
end