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

  def summary
    "#{beer.name} got #{score} points from #{user.username} on #{updated_at.to_date.strftime('%d.%m.%Y')} at #{updated_at.strftime('%H:%M:%S')}"
  end

  def rated
    updated_at.to_date.strftime('%d.%m.%Y')
  end

  # users with most ratings, @top_raters
  def self.top(number)
    User.all.sort_by { |user| user.ratings.count }.reverse[..number - 1]
  end
end
