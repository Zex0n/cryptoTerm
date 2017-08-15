class AddBtcInvestedCurrentToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :btc_investing, :float, null: false, default: 0.0
  end
end
