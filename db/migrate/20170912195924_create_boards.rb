class CreateBoards < ActiveRecord::Migration[5.1]
  def change
    create_table :boards do |t|
      t.belongs_to :company, foreign_key: true
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
