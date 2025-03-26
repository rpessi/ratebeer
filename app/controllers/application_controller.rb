class ApplicationController < ActionController::Base
  # määritellään, että metodi current_user tulee käyttöön myös näkymissä
  helper_method :current_user

  def current_user
    # uses cache for memoization
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
