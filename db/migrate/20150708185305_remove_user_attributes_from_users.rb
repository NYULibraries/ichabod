class RemoveUserAttributesFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :user_attributes
  end

  def down
    add_column :users, :user_attributes, :text
  end
end
