class SessionsController < ApplicationController
  before_action :set_admin, only: %i[create]
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    # binding.pry
    # @admin = user&.admin?
    # haetaan user ja tarkistetaan salasana
    # use safe navigation operator to check if nil before calling authenticate
    if user&.blocked?
      redirect_to signin_path, notice: "Your account is closed, please contact with admin"
    elsif user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!" # redirect_to user_path(user)
    else
      redirect_to signin_path, notice: "Username and/or password mismatch!"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end
end
