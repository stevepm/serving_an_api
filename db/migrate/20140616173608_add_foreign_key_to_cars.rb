class AddForeignKeyToCars < ActiveRecord::Migration
  def change
    add_column :cars, :make, :string
    add_index :cars, :make
  end
end
