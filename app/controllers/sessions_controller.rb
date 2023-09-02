class SessionsController < ApplicationController
  def create
    user = User.find_or_create_with_omniauth(request.env['omniauth.auth'])
    session[:user_id] = user.id
    redirect_to after_sign_in_path, notice: "Signed in as #{user.name}"
  end

  def failure
    Sentry.capture_message(params[:message])
    redirect_to root_url, alert: 'Authentication failed.'
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: 'Signed out'
  end

  private

  def after_sign_in_path
    request.env['omniauth.params']['after_sign_in_path'] || request.env['omniauth.origin'] || home_path
  end
end
