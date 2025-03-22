class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

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
