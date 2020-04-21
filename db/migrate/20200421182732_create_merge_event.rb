class CreateMergeEvent < ActiveRecord::Migration[5.2]
  def up
    create_table :merge_events do |t|
      t.bigint :primary_post_id
      t.bigint :secondary_post_id
      t.bigint :admin_id
      t.bigint :company_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def down
    drop_table :merge_events
  end
end
