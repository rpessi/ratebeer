class Style < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    name
  end

  def self.ratings_by_style
    grouped_ratings = Rating.all.group_by { |rating| rating.beer.style.name }
    grouped_ratings.transform_values do |style_ratings|
      total_score = style_ratings.sum(&:score)
      (total_score.to_f / style_ratings.size).round(1)
    end
  end

  def self.top(number)
    # return nil if ratings.empty?

    # return Style.find(ratings[0].beer_id).style.name if ratings.count == 1

    averages_by_style = ratings_by_style
    averages_by_style.sort_by{ |_style, avg_score| avg_score }.reverse[..number - 1]
  end
end
