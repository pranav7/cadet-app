class AddSlugIndexScopedToCompanyId < ActiveRecord::Migration[5.1]
  def change
    add_index :boards, [:slug, :company_id], unique: true
    add_index :posts, [:slug, :board_id], unique: true
  end
end
