class AddDeletedAtToForumThreads < ActiveRecord::Migration[5.0]
  def change
    add_column :forum_threads, :deleted_at, :datetime
    add_index :forum_threads, :deleted_at
  end
end
