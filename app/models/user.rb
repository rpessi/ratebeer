class User < ApplicationRecord
  include RatingAverage

  validates :username, uniqueness: true,
                       length: { in: 3..30 }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  def rating_summary
    if not ratings.count == 0
      return "User has made #{ratings.count} #{'rating'.pluralize(ratings.count)}, average rating #{average_rating}"
    else
      "User has no ratings."
    end
  end

  # list of the names of the beerclubs the user has membembership in
  def club_names
    beer_clubs.map{ |club| club.to_s}
  end

end
