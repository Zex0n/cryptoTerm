class AddBuyPriceToWallets < ActiveRecord::Migration[5.1]
  def change
    add_column :wallets, :buy_price, :decimal, precision: 30, scale: 10, :null => false, :default => 0
  end
end
