class AddDefaultValuesToUsers < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :admin, from: nil, to: false
    change_column_default :users, :blocked, from: nil, to: false

    User.where(admin: nil).update_all(admin: false)
    User.where(blocked: nil).update_all(blocked: false)
  end
end
