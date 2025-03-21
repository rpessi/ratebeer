class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy

  def rating_summary
    "Beer has #{ratings.count} #{'rating'.pluralize(ratings.count)} with an average of #{average_rating}"
  end

  def to_s
    return "#{self.name}, #{self.brewery.name}"
  end
end
