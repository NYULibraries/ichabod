class DropCollectionTable < ActiveRecord::Migration
def up
    drop_table :collections
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
