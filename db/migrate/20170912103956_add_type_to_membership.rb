class AddTypeToMembership < ActiveRecord::Migration[5.1]
  def change
    add_column :memberships, :type, :integer, default: 0
  end
end
