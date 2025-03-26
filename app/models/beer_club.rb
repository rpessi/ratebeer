class BeerClub < ApplicationRecord
  has_many :memberships
  has_many :members, through: :memberships, source: :user

  def to_s
    "#{name}, #{city}"
  end

  def member_names
    members.map(& :username)
  end
end
