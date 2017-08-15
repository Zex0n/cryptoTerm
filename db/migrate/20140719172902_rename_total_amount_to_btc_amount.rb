class RenameTotalAmountToBtcAmount < ActiveRecord::Migration[5.1]
  def change
    rename_column :orders_histories, :total_amount, :btc_amount
  end
end
