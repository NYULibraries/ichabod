class CreateCollections < ActiveRecord::Migration
  def change
    create_table :collections do |t|
      t.string :identifier
      t.string :title
      t.string :creator
      t.string :publisher
      t.string :description
      t.string :available
      t.string :rights

      t.timestamps
    end
  end
end
