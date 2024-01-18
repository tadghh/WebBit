class AddUnsubscribeHashToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :unsubscribed_hash, :string
  end
end
