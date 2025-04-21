module TopRated
  extend ActiveSupport::Concern

  # for Style, Brewery and Beer
  def top(number)
    sorted = all.sort_by(&:average_rating).reverse
    sorted[..number - 1]
  end
end
