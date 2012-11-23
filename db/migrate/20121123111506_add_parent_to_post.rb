class AddParentToPost < ActiveRecord::Migration
  def change
    add_column :posts, :newest, :boolean, :default => true
    add_column :posts, :parent_id, :integer
  end
end
