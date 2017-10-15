class AddLastActivityAtToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :last_activity_at, :datetime
  end
end
