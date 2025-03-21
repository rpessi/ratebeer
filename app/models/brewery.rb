class Brewery < ApplicationRecord
  has_many :beers

  def print_report
    puts name
    puts "Established at year #{year}"
    puts "Number of beers #{beers.count}"
  end

  def restart
    self.year = 2022
    puts "changed year to #{year}"
  end
end
