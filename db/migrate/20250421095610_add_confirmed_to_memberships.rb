class AddConfirmedToMemberships < ActiveRecord::Migration[7.1]
  def change
    add_column :memberships, :confirmed, :boolean

    Membership.where(confirmed: nil).update_all(confirmed: true)
  end
end
