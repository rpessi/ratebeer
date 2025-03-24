class RatingsController < ApplicationController
  before_action :set_rating, only: %i[show]

  def index
    @ratings = Rating.all
    # render :index - renderöidään oletusarvona
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    rating = Rating.create params.require(:rating).permit(:score, :beer_id)
    rating.user = current_user
    rating.save
    redirect_to current_user
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete
    redirect_to ratings_path
  end

  private

  # Use callbacks to share common setup or constraints
  # between actions.
  def set_rating
    @rating = Rating.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def rating_params
    params.require(:rating).permit(:score, :beer_id)
  end
end
