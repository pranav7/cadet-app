class CreateChangelogPosts < ActiveRecord::Migration[5.2]
  def change
    create_table :changelog_posts do |t|
      t.text :title
      t.text :status
      t.text :content
      t.text :subdomain

      t.timestamps
    end
  end
end
