class CreateLikedislikes < ActiveRecord::Migration
  def change
    create_table :likedislikes do |t|
      t.integer :liker
      t.integer :post_id
      t.boolean :liked
      t.references :post
      t.timestamps
    end
  end
end
