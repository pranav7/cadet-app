class AddBoardsToPost < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :board, foreign_key: true, index: true
  end
end
