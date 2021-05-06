class AddSourceAndIdentifierFieldsToAccount < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :source, :string, default: "Cadet"
    add_column :accounts, :source_identifier, :string
  end
end
