class RemoveStyleFromBeers < ActiveRecord::Migration[7.1]
  def change
    remove_column :beers, :style, :string
  end
end
