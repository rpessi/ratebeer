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
end
