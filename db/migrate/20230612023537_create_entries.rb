class CreateEntries < ActiveRecord::Migration[7.0]
  
  def change
    create_table :entries do |t|
      t.string :title
      t.text :body
      t.integer :blog_id

      t.timestamps
    end
  end
end
