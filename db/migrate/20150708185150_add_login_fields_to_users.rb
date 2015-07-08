class AddLoginFieldsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :provider, :string, null: false, default: ""
    add_column :users, :aleph_id, :string
    add_column :users, :institution_code, :string
    add_column :users, :patron_status, :string
  end

  def down
    remove_column :users, :provider
    remove_column :users, :aleph_id
    remove_column :users, :institution_code
    remove_column :users, :patron_status
  end
end
