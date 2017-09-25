class AddColumnsToCoins < ActiveRecord::Migration[5.1]
  def change
    add_column :coins, :bid, :decimal, precision: 30, scale: 10, :null => false, :default => 0
    add_column :coins, :ask, :decimal, precision: 30, scale: 10, :null => false, :default => 0
  end
end
