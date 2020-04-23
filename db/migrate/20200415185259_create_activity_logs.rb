class CreateActivityLogs < ActiveRecord::Migration[5.2]
  def up
    create_table :activity_logs do |t|
      t.integer :event_type
      t.bigint :event_id
      t.bigint :company_id
      t.integer :visibility
      t.bigint :post_id
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps

      t.index :post_id
      t.index :company_id
    end
  end

  def down
    drop_table :activity_logs
  end

end
