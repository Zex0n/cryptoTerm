class AddNameToApi < ActiveRecord::Migration[5.1]
  def change
    add_column :api_keys, :name, :string
  end
end
