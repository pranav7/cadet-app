class AddDefaultSortOrderToBoards < ActiveRecord::Migration[5.2]
  def change
    add_column :boards, :default_sort_order, :integer
  end
end
