class AddApikeyIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :apikey_id, :integer

    User.all.each do |user|
      unless user.api_key.present?
        user.add_new_api_key
      end
    end
  end
end
