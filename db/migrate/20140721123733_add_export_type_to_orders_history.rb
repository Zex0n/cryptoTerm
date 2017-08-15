class AddExportTypeToOrdersHistory < ActiveRecord::Migration[5.1]
  def change
    add_column :orders_histories, :added_by, :integer, null: false, default: 0
  end
end
