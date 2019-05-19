class AddUnlistedBooleanToBoards < ActiveRecord::Migration[5.2]
  def change
    add_column :boards, :unlisted, :boolean, default: false
  end
end
