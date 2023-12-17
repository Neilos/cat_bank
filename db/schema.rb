# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2023_12_17_123751) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.uuid "reference", default: -> { "gen_random_uuid()" }
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "index_accounts_on_reference", unique: true
  end

  create_table "money_transaction_items", force: :cascade do |t|
    t.bigint "money_transaction_id", null: false
    t.bigint "account_id", null: false
    t.bigint "next_account_item_id"
    t.datetime "next_account_item_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_money_transaction_items_on_account_id"
    t.index ["money_transaction_id"], name: "index_money_transaction_items_on_money_transaction_id"
    t.index ["next_account_item_id"], name: "index_money_transaction_items_on_next_account_item_id"
  end

  create_table "money_transactions", force: :cascade do |t|
    t.uuid "reference", default: -> { "gen_random_uuid()" }
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reference"], name: "index_money_transactions_on_reference", unique: true
  end

  add_foreign_key "money_transaction_items", "accounts"
  add_foreign_key "money_transaction_items", "money_transaction_items", column: "next_account_item_id"
  add_foreign_key "money_transaction_items", "money_transactions"
end
