class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      #session[:user_id] = user.id
      redirect_to root_url, notice: 'Logged In '
    else
      flash.alert = 'Invalid'
      render 'new'
    end
  end

  def destroy
    #session[:user_id] = nil
    cookies.delete(:auth_token)
    redirect_to root_url, notice: 'Logged out'
  end
end
