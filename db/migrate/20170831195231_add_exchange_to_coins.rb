class AddExchangeToCoins < ActiveRecord::Migration[5.1]
  def change
    add_reference :coins, :exchange, foreign_key: true
  end
end
