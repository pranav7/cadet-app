class AddPolymorphicToContent < ActiveRecord::Migration[5.1]
  def change
    add_reference :contents, :parent, polymorphic: true, index: true 
  end
end
