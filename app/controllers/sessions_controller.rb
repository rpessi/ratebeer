class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    user = User.find_by username: params[:username]
    # haetaan user ja tarkistetaan salasana
    # use safe navigation operator to check if nil before calling authenticate
    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to user, notice: "Welcome back!" # redirect_to user_path(user)
    else
      redirect_to signin_path, notice: "Username and/or password mismatch!"
    end
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end
