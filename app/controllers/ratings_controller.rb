class RatingsController < ApplicationController
  PAGE_SIZE = 5

  def index
    @top_breweries = Brewery.top 3
    @top_beers = Beer.top 3
    @top_styles = Style.top 3
    @top_raters = Rating.top 3
    @order = params[:order] || "up" # latest first
    @page = params[:page]&.to_i || 1
    @last_page = (Rating.count / PAGE_SIZE.to_f).ceil
    offset = (@page - 1) * PAGE_SIZE

    @ratings = case @order
               when "down" then Rating.order(:updated_at)
                                      .limit(PAGE_SIZE).offset(offset)
               when "up" then Rating.order(updated_at: :desc)
                                    .limit(PAGE_SIZE).offset(offset)
               end
  end

  def toggle_arrow
    @current_order = params[:order]
    @page = params[:page]
    @order = @current_order == "up" ? "down" : "up"

    redirect_to ratings_path(page: @page, order: @order)
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
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
    destroy_ids = request.body.string.split(',')

    destroy_ids.each do |id|
      rating = Rating.find_by(id: id)
      rating.destroy if rating && current_user == rating.user
    rescue StandardError => e
      puts "Rating record has an error: #{e.message}"
    end
    @user = current_user
    respond_to do |format|
      format.html { render partial: '/users/ratings', status: :ok, user: @user }
    end
  end
end
