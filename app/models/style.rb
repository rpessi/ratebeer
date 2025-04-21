class Style < ApplicationRecord
  include RatingAverage
  extend TopRated

  validates :name, presence: true
  validates :description, presence: true

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  def to_s
    name
  end
end
