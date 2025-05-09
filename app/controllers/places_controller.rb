class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])

    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:city] = params[:city]
      render :index, status: 418
    end
  end

  def show
    # I don't know how to do this without cache and not ending up with cookieoverflow
    # Will change the index view to have more content and remove the links
    # @places = Rails.cache.fetch(session[:city])
    # @place = @places.find { |place| place[:id] = params[:id] }
  end
end
