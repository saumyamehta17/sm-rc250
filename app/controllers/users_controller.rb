class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = params[:user].nil? ?  User.new_guest : User.new(user_params)
    if @user.save
      current_user.move_to(@user) if current_user && current_user.guest?
      #session[:user_id] = @user.id
      cookies[:auth_token] = @user.auth_token
      redirect_to root_url, notice:  'User created'
    else
      render 'new'
    end
  end

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
