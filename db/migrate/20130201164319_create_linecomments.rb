class CreateLinecomments < ActiveRecord::Migration
  def change
    create_table :linecomments do |t|
      t.string :commenter, :default => "Anonymous"
      t.text :body
      t.references :post
      t.integer :line

      t.timestamps
    end
    add_index :linecomments, :post_id
  end
end
