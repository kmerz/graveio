class AddContentType < ActiveRecord::Migration
  def up
    add_column :posts, :content_type, :string
  end

  def down
    remove_column :posts, :content_type
  end
end
