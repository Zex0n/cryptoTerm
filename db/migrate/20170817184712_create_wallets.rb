class CreateWallets < ActiveRecord::Migration[5.1]
  def change
    create_table :wallets do |t|
      t.references :user, foreign_key: true
      t.references :exchange, foreign_key: true
      t.references :coin, foreign_key: true
      t.decimal :balance, precision: 30, scale: 10
      t.decimal :available, precision: 30, scale: 10
      t.decimal :pending, precision: 30, scale: 10

      t.timestamps
    end
  end
end
