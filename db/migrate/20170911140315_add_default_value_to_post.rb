class AddDefaultValueToPost < ActiveRecord::Migration[5.1]
  def change
    change_column :posts, :status, :integer, default: 0
  end
end
