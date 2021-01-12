class CreateChangelogEntries < ActiveRecord::Migration[5.2]
  def change
    create_table :changelog_entries do |t|
      t.text :title
      t.integer :status
      t.string :slug
      t.belongs_to :company, foreign_key: true

      t.timestamps
    end
  end
end
