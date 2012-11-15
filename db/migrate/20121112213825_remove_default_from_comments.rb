class RemoveDefaultFromComments < ActiveRecord::Migration
  def up
    change_column_default(:comments, :commenter, nil)
  end

  def down
    change_column_default(:comments, :commenter, "Anonymus")
  end
end
