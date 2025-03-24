class Rating < ApplicationRecord
  belongs_to :beer
  belongs_to :user   # rating kuuluu myös käyttäjään

  def print_report #check if replaced _everywhere_ with to_s before removing
    "#{beer.name} #{score}"
  end

  def to_s
    "#{beer.name} #{score}"
  end
end
