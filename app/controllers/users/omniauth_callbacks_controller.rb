# app/controllers/users/omniauth_callbacks_controller.rb
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # Retrieve auth data from Google
    auth = request.env['omniauth.auth']
    
    # Find or create user
    @user = User.from_omniauth(auth)

    # Store tokens for Gmail API access
    if @user.persisted?
      @user.update(
        google_token: auth.credentials.token,
        google_refresh_token: auth.credentials.refresh_token,
        google_expires_at: Time.at(auth.credentials.expires_at)
      )
      
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session["devise.google_data"] = auth.except(:extra)
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end

  def failure
    redirect_to root_path, alert: "Failed to authenticate with Google."
  end
end