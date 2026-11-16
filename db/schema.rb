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

ActiveRecord::Schema[7.1].define(version: 2026_11_16_095815) do
  create_table "categories", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.text "address"
    t.string "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
  end

  create_table "hotels", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "contact_person"
    t.string "phone"
    t.text "address"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "sku"
    t.text "description"
    t.bigint "category_id", null: false
    t.decimal "purchase_price", precision: 12, scale: 2
    t.decimal "selling_price", precision: 12, scale: 2
    t.integer "quantity", default: 0
    t.integer "minimum_stock"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
  end

  create_table "stock_balances", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "category_id", null: false
    t.decimal "quantity", precision: 12, scale: 3, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_stock_balances_on_category_id"
    t.index ["company_id", "category_id"], name: "index_stock_balances_on_company_id_and_category_id", unique: true
    t.index ["company_id"], name: "index_stock_balances_on_company_id"
  end

  create_table "stock_transactions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "category_id", null: false
    t.bigint "hotel_id"
    t.string "transaction_type"
    t.decimal "quantity", precision: 12, scale: 3, null: false
    t.decimal "rate", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "balance_after", precision: 12, scale: 3, null: false
    t.date "transaction_date", null: false
    t.text "remarks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_stock_transactions_on_category_id"
    t.index ["company_id", "category_id"], name: "index_stock_transactions_on_company_category"
    t.index ["company_id"], name: "index_stock_transactions_on_company_id"
    t.index ["hotel_id"], name: "index_stock_transactions_on_hotel_id"
    t.index ["transaction_date"], name: "index_stock_transactions_on_transaction_date"
    t.index ["transaction_type"], name: "index_stock_transactions_on_transaction_type"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "jti", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "products", "categories"
  add_foreign_key "stock_balances", "categories"
  add_foreign_key "stock_balances", "companies"
  add_foreign_key "stock_transactions", "categories"
  add_foreign_key "stock_transactions", "companies"
  add_foreign_key "stock_transactions", "hotels"
end
