class Brewery < ApplicationRecord
  include RatingAverage

  validate :year_cannot_be_in_the_future, on: :create

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   only_integer: true }

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def year_cannot_be_in_the_future
    return unless year > Time.now.year

    errors.add(:year, "can't be in the future.")
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
    puts "changed year to #{year}"
  end
end
