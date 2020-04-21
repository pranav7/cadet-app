class CreateActivityLogs < ActiveRecord::Migration[5.2]
  def up
    create_table :activity_logs do |t|
      t.integer :event_type
      t.bigint :event_id
      t.bigint :company_id
      t.string :visibility
      t.bigint :post_id
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end
  end

  def down
    drop_table :activity_logs
  end

end
