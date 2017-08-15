class CreateExchanges < ActiveRecord::Migration[5.1]
  def change
    create_table :exchanges do |t|
      t.string :name
      t.string :short_name
      t.string :url

      t.timestamps
    end
  end
end
