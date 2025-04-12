class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { in: 3..30 }
  validates :password, length: { minimum: 4, message: "Password must have at least 4 chacters." },
                       format: { with: /([a-zA-Z]*[A-Z]+[a-zA-Z]*[0-9]+[a-zA-Z]*|[a-zA-Z]*[0-9]+[a-zA-Z]*[A-Z]+[a-zA-Z]*)/,
                                 message: "Password must have at least one capital letter and one number." }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  scope :admin, -> { where(admin: true) }

  def rating_summary
    if ratings.count == 0
      "User has no ratings."
    else
      "User has made #{ratings.count} #{'rating'.pluralize(ratings.count)}, average rating #{average_rating}"
    end
  end

  # list of the names of the beerclubs the user has membembership in
  def club_names
    beer_clubs.map(& :to_s)
  end

  def favorite_beer
    return nil if ratings.empty?

    ratings.max_by(&:score).beer
  end

  def ratings_by_style
    grouped_ratings = ratings.group_by { |rating| rating.beer.style.name }
    grouped_ratings.transform_values do |style_ratings|
      total_score = style_ratings.sum(&:score)
      total_score.to_f / style_ratings.size
    end
  end

  # favorite style = max average rating for a beer.style
  def favorite_style
    return nil if ratings.empty?

    return Beer.find(ratings[0].beer_id).style.name if ratings.count == 1

    averages_by_style = ratings_by_style
    averages_by_style.max_by { |_style, avg_score| avg_score }&.first
  end

  def ratings_by_brewery
    grouped_ratings = ratings.group_by { |rating| rating.beer.brewery_id }
    grouped_ratings.transform_values do |brewery_ratings|
      total_score = brewery_ratings.sum(&:score)
      total_score.to_f / brewery_ratings.size
    end
  end

  def favorite_brewery
    return nil if ratings.empty?

    if ratings.count == 1
      ratings.first.beer.brewery.name
    else
      averages_by_brewery = ratings_by_brewery
      brewery_id = averages_by_brewery.max_by { |_brewery_id, avg_score| avg_score }&.first
      Brewery.find(brewery_id).name
    end
  end
end
