class AddUserAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :user_attributes, :text
  end
end
