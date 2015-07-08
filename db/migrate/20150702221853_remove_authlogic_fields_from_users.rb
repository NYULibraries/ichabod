class RemoveAuthlogicFieldsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :mobile_phone
    remove_column :users, :crypted_password
    remove_column :users, :password_salt
    remove_column :users, :session_id
    remove_column :users, :persistence_token
    remove_column :users, :login_count
    remove_column :users, :last_request_at
    remove_column :users, :current_login_at
    remove_column :users, :last_login_at
    remove_column :users, :last_login_ip
    remove_column :users, :current_login_ip
  end

  def down
    add_column :users, :mobile_phone
    add_column :users, :crypted_password
    add_column :users, :password_salt
    add_column :users, :session_id
    add_column :users, :persistence_token
    add_column :users, :login_count
    add_column :users, :last_request_at
    add_column :users, :current_login_at
    add_column :users, :last_login_at
    add_column :users, :last_login_ip
    add_column :users, :current_login_ip
  end
end
