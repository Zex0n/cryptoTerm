class AddLastTradeToTrades < ActiveRecord::Migration[5.1]
  def change
    add_column :trades, :last_trade, :datetime
  end
end
