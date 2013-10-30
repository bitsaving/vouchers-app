# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131030045245) do

  create_table "accounts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",     default: true
  end

  create_table "admins", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.text     "description"
    t.integer  "user_id"
    t.integer  "voucher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree
  add_index "comments", ["voucher_id"], name: "index_comments_on_voucher_id", using: :btree

  create_table "uploads", force: true do |t|
    t.integer  "voucher_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",       null: false
    t.string   "encrypted_password",     default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "user_type",              default: "normal"
    t.time     "deleted_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vouchers", force: true do |t|
    t.date     "date"
<<<<<<< HEAD
    t.string   "payment_type"
    t.integer  "account_debited"
    t.integer  "account_credited"
=======
<<<<<<< HEAD
    t.string   "payment_type"
    t.integer  "account_debited"
    t.integer  "account_credited"
=======
<<<<<<< HEAD
    t.string   "payment_type"
    t.integer  "account_debited"
    t.integer  "account_credited"
=======
    t.string   "pay_type"
    t.string   "reference"
    t.integer  "debit_from_id"
    t.integer  "credit_to_id"
    t.integer  "user_id"
>>>>>>> 3cd885915b7726b2726707acbcdba4561818f7e6
>>>>>>> b5a45e7b6ce0c9f6da9cff1281d61989c0096a58
>>>>>>> f01e2da8c6384e5dff3e14723a433bf8bf33d6e2
    t.date     "from_date"
    t.date     "to_date"
    t.decimal  "amount",            precision: 8, scale: 2
    t.integer  "transfer_from_id"
    t.integer  "transfer_to_id"
    t.integer  "assigned_to_id"
    t.datetime "created_at"
    t.datetime "updated_at"
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> b5a45e7b6ce0c9f6da9cff1281d61989c0096a58
>>>>>>> f01e2da8c6384e5dff3e14723a433bf8bf33d6e2
    t.integer  "creator_id"
    t.string   "payment_reference"
    t.integer  "assignee_id"
    t.string   "workflow_state"
  end

  add_index "vouchers", ["account_credited"], name: "index_vouchers_on_account_credited", using: :btree
  add_index "vouchers", ["account_debited"], name: "index_vouchers_on_account_debited", using: :btree
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
=======
  end

  add_index "vouchers", ["assigned_to_id"], name: "index_vouchers_on_assigned_to_id", using: :btree
  add_index "vouchers", ["credit_to_id"], name: "index_vouchers_on_credit_to_id", using: :btree
  add_index "vouchers", ["debit_from_id"], name: "index_vouchers_on_debit_from_id", using: :btree
>>>>>>> 3cd885915b7726b2726707acbcdba4561818f7e6
>>>>>>> b5a45e7b6ce0c9f6da9cff1281d61989c0096a58
>>>>>>> f01e2da8c6384e5dff3e14723a433bf8bf33d6e2
  add_index "vouchers", ["transfer_from_id"], name: "index_vouchers_on_transfer_from_id", using: :btree
  add_index "vouchers", ["transfer_to_id"], name: "index_vouchers_on_transfer_to_id", using: :btree
  add_index "vouchers", ["user_id"], name: "index_vouchers_on_user_id", using: :btree

end
