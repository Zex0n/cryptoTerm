class AddTradeToOrdersHistories < ActiveRecord::Migration[5.1]
  def change
    add_reference :orders_histories, :trade, index: true
  end
end
