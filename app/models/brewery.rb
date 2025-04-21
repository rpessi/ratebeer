class Brewery < ApplicationRecord
  include RatingAverage
  extend TopRated

  validate :year_cannot_be_in_the_future_or_nil
  validates :name, presence: true
  validates :year, numericality: { greater_than: 1039,
                                   only_integer: true }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def year_cannot_be_in_the_future_or_nil
    if year.nil?
      errors.add(:year, "can't be blank")
    elsif year > Time.now.year
      errors.add(:year, "can't be in the future.")
    end
  end

  def print_report
    puts name
    puts "Established at year #{year}"
    puts "Number of beers #{beers.count}"
  end

  def rating_summary
    "Brewery has #{ratings.count} #{'rating'.pluralize(ratings.count)}
    with an average of #{average_rating}"
  end

  def restart
    self.year = 2022
    puts "Changed year to #{year}"
  end
end
