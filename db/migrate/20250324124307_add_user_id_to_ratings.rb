class AddUserIdToRatings < ActiveRecord::Migration[7.1]
  def change
    add_column :ratings, :user_id, :integer
  end
end
