class AddIndexToTitle < ActiveRecord::Migration[5.2]
  def change
    add_index :posts, :title
  end
end
