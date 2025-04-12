class ApplicationController < ActionController::Base
  # määritellään, että metodi current_user tulee käyttöön myös näkymissä
  helper_method :current_user

  def current_user
    # uses cache for memoization
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def ensure_that_signed_in
    redirect_to signin_path, notice: 'You should be signed in' if current_user.nil?
  end

  def set_admin
    @admin = current_user&.admin?
  end

  def set_blocked_users
    @blocked_users = User.blocked
  end
end
