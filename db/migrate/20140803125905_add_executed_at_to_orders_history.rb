class AddExecutedAtToOrdersHistory < ActiveRecord::Migration[5.1]
  def change
    add_column :orders_histories, :executed_at, :datetime
    OrdersHistory.update_all('executed_at= created_at')
  end
end
