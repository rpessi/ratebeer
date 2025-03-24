class User < ApplicationRecord
  include RatingAverage

  has_many :ratings, dependent: :destroy # käyttäjällä on monta ratingia, orvot tuhotaan

  def rating_summary
    if not ratings.count == 0
      return "User has made #{ratings.count} #{'rating'.pluralize(ratings.count)}, average rating #{average_rating}"
    else
      "User has no ratings."
    end
  end
end
