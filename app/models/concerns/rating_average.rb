module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0 if ratings.empty?

    (ratings.map(&:score).sum / ratings.count.to_f).round(1)
  end
end
