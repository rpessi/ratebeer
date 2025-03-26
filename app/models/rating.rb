class Rating < ApplicationRecord
  belongs_to :beer
  belongs_to :user   # rating kuuluu myös käyttäjään

  validates :score, numericality: { greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 50,
                                    only_integer: true }

  # check if replaced _everywhere_ with to_s before removing
  def print_report
    "#{beer.name} #{score}"
  end

  def to_s
    "#{beer.name} #{score}"
  end
end
