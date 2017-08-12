class CreateApiKeys < ActiveRecord::Migration[5.1]
  def change
    create_table :api_keys do |t|
      t.string :name
      t.integer :sort
      t.string :open
      t.string :secret
      t.references :user, foreign_key: true
      t.references :exchange, foreign_key: true

      t.timestamps
    end
  end
end
