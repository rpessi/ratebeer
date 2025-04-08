class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:last_places] = @places.to_h do |place|
        [place.id, { name: place.name, city: place.city,
                     street: place.street, status: place.status, zip: place.zip }]
      end
      render :index, status: 418
    end
  end

  def show
    @place = session[:last_places][params[:id]]
  end
end
