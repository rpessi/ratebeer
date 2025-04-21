class Rating < ApplicationRecord
  belongs_to :beer, touch: true
  belongs_to :user # rating kuuluu myös käyttäjään

  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  scope :latest, -> { reverse_order[..4] }

  def to_s
    "#{beer.name} #{score}"
  end

  # users with most ratings, @top_raters
  def self.top(number)
    User.all.sort_by { |user| user.ratings.count }.reverse[..number - 1]
  end

  def self.last(number)
    Rating.all.sort_by(&:updated_at).reverse[..number - 1]
  end
end
