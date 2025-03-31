class Membership < ApplicationRecord
  validate :membership_must_not_exist

  belongs_to :beer_club
  belongs_to :user

  def to_s
    "#{user.username}: #{beer_club.name}"
  end

  private

  def membership_must_not_exist
    return unless Membership.exists?(user_id: user_id, beer_club_id: beer_club_id)

    errors.add(:base, "You are already a member of this beer club.")
  end
end
