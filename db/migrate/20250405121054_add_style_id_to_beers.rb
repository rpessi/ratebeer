class AddStyleIdToBeers < ActiveRecord::Migration[7.1]
  def change
    add_column :beers, :style_id, :integer
  end
end
