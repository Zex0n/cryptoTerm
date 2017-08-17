json.extract! wallet, :id, :user_id, :exchange_id, :coin_id, :balance, :available, :pending, :created_at, :updated_at
json.url wallet_url(wallet, format: :json)
