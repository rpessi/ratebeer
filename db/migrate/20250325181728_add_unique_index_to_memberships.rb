class AddUniqueIndexToMemberships < ActiveRecord::Migration[7.1]
  def change
    add_index :memberships, [:user_id, :beer_club_id], unique: true
  end
end
