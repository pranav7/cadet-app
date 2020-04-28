class CreateStatusChangedEvents < ActiveRecord::Migration[5.2]
  def up
    create_table :status_changed_events do |t|
      t.integer :old_value
      t.integer :new_value
      t.integer :admin_id
      t.bigint :company_id
      t.bigint :post_id
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end

  def down
    drop_table :status_changed_events
  end
end
