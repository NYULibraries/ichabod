class AddRefreshedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :refreshed_at, :datetime
  end
end
