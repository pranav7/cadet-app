class AddCompanyToPost < ActiveRecord::Migration[5.1]
  def change
    add_reference :posts, :company, foreign_key: true, index: true
  end
end
