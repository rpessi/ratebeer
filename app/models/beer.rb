class Beer < ApplicationRecord
  include RatingAverage

  validates :name, presence: true,
                   uniqueness: true
  validates :style_id, presence: true
  validates :brewery_id, presence: true

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  def rating_summary
    "Beer has #{ratings.count} #{'rating'.pluralize(ratings.count)} with an average of #{average_rating}"
  end

  def to_s
    "#{name}, #{brewery.name}"
  end
end
