class AddUserIndexBasedOnUsername < ActiveRecord::Migration[7.1]
  def change
    add_index :users, :username
  end
end
