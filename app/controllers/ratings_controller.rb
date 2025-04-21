class RatingsController < ApplicationController
  after_action :expire_brewery_cache, only: %i[create destroy]
  after_action :expire_beer_cache, only: %i[create destroy]

  def index
    # simple caching, taking into consideration the the speed
    # of change and speed of query Beer.top 3 is likely to change
    # faster than Brewery top 3. Rating.last 5 is a single and
    # fast query, no need for longer cache duration.
    @last_ratings = Rails.cache.fetch("last_ratings", expires_in: 10.minutes) {
      @last_ratings = Rating.last 5
    }
    @top_breweries = Rails.cache.fetch("top_breweries", expires_in: 20.minutes) {
      @top_breweries = Brewery.top 3
    }
    @top_beers = Rails.cache.fetch("top_beers", expires_in: 10.minutes) {
      @top_beers = Beer.top 3
    }
    @top_styles = Rails.cache.fetch("top_styles", expires_in: 20.minutes) {
      @top_styles = Style.top 3
    }
    @top_raters = Rails.cache.fetch("top_raters", expires_in: 10.minutes) {
      @top_raters = Rating.top 3
    }
  end

  def new
    @rating = Rating.new
    @beers = Rails.cache.fetch("beers for rating", expires_in: 10.minutes) {
      @beers = Beer.all
    }
  end

  def create
    @rating = Rating.create params.require(:rating).permit(:score, :beer_id)
    @rating.user = current_user

    if @rating.save
      redirect_to user_path current_user
    else
      redirect_to new_rating_path, notice: "Rating must be an integer in range of 1-50."
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to user_path(current_user)
  end
end
