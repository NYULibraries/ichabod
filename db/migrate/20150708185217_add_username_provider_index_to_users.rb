class AddUsernameProviderIndexToUsers < ActiveRecord::Migration
  def up
    add_index :users, [:username, :provider], unique: true
  end

  def down
    remove_index :users, [:username, :provider]
  end
end
