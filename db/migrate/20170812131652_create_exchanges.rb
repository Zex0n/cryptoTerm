class CreateExchanges < ActiveRecord::Migration[5.1]
  def change
    create_table :exchanges do |t|
      t.string :name
      t.integer :sort

      t.timestamps
    end
  end
end
