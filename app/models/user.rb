class User < ApplicationRecord
  include RatingAverage

  has_secure_password

  validates :username, uniqueness: true,
                       length: { in: 3..30 }
  validates :password, length: { minimum: 4, message: "Password must have at least 4 chacters." },
                       format: { with: /([a-zA-Z]*[A-Z]+[a-zA-Z]*[0-9]+[a-zA-Z]*|[a-zA-Z]*[0-9]+[a-zA-Z]*[A-Z]+[a-zA-Z]*)/,
                                 message: "Password must have at least one capital letter and one number." }

  has_many :ratings, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships

  scope :admin, -> { where(admin: true) }
  scope :blocked, -> { where(blocked: true) }

  def rating_summary
    if ratings.count == 0
      "#{username} has no ratings."
    else
      "#{username} has made #{ratings.count} #{'rating'.pluralize(ratings.count)}, average rating #{average_rating}"
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

  def favorite_style
    favorite(:style)
  end

  def favorite_brewery
    favorite(:brewery)
  end

  def favorite(grouped_by)
    return nil if ratings.empty?

    grouped_ratings = ratings.group_by { |rating| rating.beer.send(grouped_by) }
    averages = grouped_ratings.transform_values do |ratings|
      total_score = ratings.sum(&:score)
      total_score.to_f / ratings.size
    end
    averages.max_by { |_r, avg_score| avg_score }&.first&.name
  end
end
