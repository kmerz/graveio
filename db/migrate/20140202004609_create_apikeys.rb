class CreateApikeys < ActiveRecord::Migration
  def change
    create_table :apikeys do |t|
      t.string :key
      t.integer :user_id

      t.timestamps
    end
  end
end
