class DropSlugIndex < ActiveRecord::Migration[5.1]
  def change
    remove_index :boards, :slug
    remove_index :posts, :slug
  end
end
