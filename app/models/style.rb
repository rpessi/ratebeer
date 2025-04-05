class Style < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true

  has_many :beers

  def to_s
    name
  end
end
