class ApplicationController < ActionController::Base
  # määritellään, että metodi current_user tulee käyttöön myös näkymissä
  helper_method :current_user

  # def test_sentry
  #  begin
  #    1 / 0
  #  rescue ZeroDivisionError => exception
  #    Sentry.capture_exception(exception)
  #  end

  #  Sentry.capture_message("test message")

  #  render plain: "Sentry test completed. Check your Sentry dashboard."
  # end

  def current_user
    # uses cache for memoization
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
