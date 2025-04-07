class AddActivityToBrewery < ActiveRecord::Migration[7.1]
  def change
    add_column :breweries, :active, :boolean
  end
end
