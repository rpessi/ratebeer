module RatingAverage
  extend ActiveSupport::Concern
 
  def average_rating
    return 0 if ratings.empty?
    scores = ratings.map {|rating| rating.score}
    sum = scores.inject(:+)
    return (sum.to_f / ratings.count).round(1)
  end

end