class CommentCreatedEvent < ActiveRecord::Migration[5.2]
  def up
    create_table :comment_created_events do |t|
      t.bigint :comment_id
      t.bigint :user_id
      t.bigint :post_id
      t.bigint :company_id
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

  def down
    drop_table :comment_created_events
  end
end
