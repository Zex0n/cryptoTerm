# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170831195231) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "exchange_id", null: false
    t.string "key", null: false
    t.string "secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["exchange_id"], name: "index_api_keys_on_exchange_id"
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "coins", force: :cascade do |t|
    t.string "name", null: false
    t.string "tag", null: false
    t.string "thread"
    t.float "current_price", default: 0.0, null: false
    t.float "current_volume", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "exchange_id"
    t.index ["exchange_id"], name: "index_coins_on_exchange_id"
  end

  create_table "exchanges", force: :cascade do |t|
    t.string "name"
    t.string "short_name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders_histories", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "coin_id", null: false
    t.bigint "exchange_id", null: false
    t.integer "order_type", default: 0, null: false
    t.float "amount", default: 0.0, null: false
    t.float "price", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid"
    t.float "btc_amount", default: 0.0, null: false
    t.integer "added_by", default: 0, null: false
    t.bigint "trade_id"
    t.datetime "deleted_at"
    t.datetime "executed_at"
    t.integer "round_number", default: 1, null: false
    t.integer "round_id"
    t.index ["coin_id"], name: "index_orders_histories_on_coin_id"
    t.index ["deleted_at"], name: "index_orders_histories_on_deleted_at"
    t.index ["exchange_id"], name: "index_orders_histories_on_exchange_id"
    t.index ["trade_id"], name: "index_orders_histories_on_trade_id"
    t.index ["user_id"], name: "index_orders_histories_on_user_id"
  end

  create_table "trades", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "coin_id", null: false
    t.float "amount_bought", default: 0.0, null: false
    t.float "price_bought", default: 0.0, null: false
    t.float "amount_sold", default: 0.0, null: false
    t.float "price_sold", default: 0.0, null: false
    t.float "amount_left", default: 0.0, null: false
    t.float "amount_value", default: 0.0, null: false
    t.float "profit", default: 0.0, null: false
    t.float "percent", default: 0.0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "average_price_bought", default: 0.0, null: false
    t.float "average_price_sold", default: 0.0, null: false
    t.datetime "deleted_at"
    t.datetime "last_trade"
    t.integer "round_number"
    t.integer "current_round_number"
    t.integer "rounds", array: true
    t.index ["coin_id"], name: "index_trades_on_coin_id"
    t.index ["deleted_at"], name: "index_trades_on_deleted_at"
    t.index ["user_id"], name: "index_trades_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "role", default: 0, null: false
    t.float "btc_invested", default: 0.0, null: false
    t.float "btc_received", default: 0.0, null: false
    t.float "trade_profit", default: 0.0, null: false
    t.integer "orders_histories_count", default: 0, null: false
    t.float "btc_investing", default: 0.0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "exchange_id"
    t.bigint "coin_id"
    t.decimal "balance", precision: 30, scale: 10, default: "0.0", null: false
    t.decimal "available", precision: 30, scale: 10, default: "0.0", null: false
    t.decimal "pending", precision: 30, scale: 10, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_id"], name: "index_wallets_on_coin_id"
    t.index ["exchange_id"], name: "index_wallets_on_exchange_id"
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

  add_foreign_key "coins", "exchanges"
  add_foreign_key "wallets", "coins"
  add_foreign_key "wallets", "exchanges"
  add_foreign_key "wallets", "users"
end
