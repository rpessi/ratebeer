class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    return 0 if ratings.empty?
    scores = ratings.map {|ratings| ratings.score}
    sum = scores.inject(:+)
    return (sum.to_f / ratings.count).round(1)
  end

  def rating_summary
    "Beer has #{ratings.count} #{'rating'.pluralize(ratings.count)} with an average of #{average_rating}"
  end

  def to_s
    return "#{self.name}, #{self.brewery.name}"
  end
end
