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

  after_destroy_commit do
    next if Rails.env.test?

    broadcast_remove_to "breweries_index", target: self
    status = active? ? "active" : "retired"
    target_id = active? ? "active_brewery_count" : "retired_brewery_count"
    broadcast_replace_to "breweries_index", partial: "breweries/brewery_count", target: target_id,
                                            locals: { status: status }
  end

  after_create_commit do
    next if Rails.env.test?

    target_id1 = active? ? "active_brewery_rows" : "retired_brewery_rows"
    broadcast_append_to "breweries_index", partial: "breweries/brewery_row", target: target_id1

    status = active? ? "active" : "retired"
    target_id2 = active? ? "active_brewery_count" : "retired_brewery_count"
    broadcast_replace_to "breweries_index", partial: "breweries/brewery_count", target: target_id2,
                                            locals: { status: status }
  end

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
