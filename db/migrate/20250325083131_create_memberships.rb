class CreateMemberships < ActiveRecord::Migration[7.1]
  def change
    create_table :memberships do |t|
      t.integer :beer_club_id
      t.integer :user_id

      t.timestamps
    end
  end
end
