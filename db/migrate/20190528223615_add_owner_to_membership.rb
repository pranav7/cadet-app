class AddOwnerToMembership < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :owner, :boolean, default: false
  end
end
