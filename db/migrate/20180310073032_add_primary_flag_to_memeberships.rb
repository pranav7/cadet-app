class AddPrimaryFlagToMemeberships < ActiveRecord::Migration[5.2]
  def change
    add_column :memberships, :primary, :boolean, default: false
  end
end
