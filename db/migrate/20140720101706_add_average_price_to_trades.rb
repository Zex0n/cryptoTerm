class AddAveragePriceToTrades < ActiveRecord::Migration[5.1]
  def change
    add_column :trades, :average_price_bought, :float, null: false, default: 0, after: :price_bought
    add_column :trades, :average_price_sold, :float, null: false, default: 0, after: :price_sold
  end
end
