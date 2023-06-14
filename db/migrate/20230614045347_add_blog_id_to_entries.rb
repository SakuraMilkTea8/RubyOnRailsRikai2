class AddBlogIdToEntries < ActiveRecord::Migration[7.0]
  def change
    add_column :entries, :blog_id, :integer
  end
end
