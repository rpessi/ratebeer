class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    sum = 0
    self.ratings.each do |rating|
      sum = sum + rating.score
    end
    return (sum.to_f / self.ratings.count).round(1)
  end
end
