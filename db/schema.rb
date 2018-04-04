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

ActiveRecord::Schema.define(version: 20_180_403_170_913) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'subscriptions', force: :cascade do |t|
    t.bigint 'user_id'
    t.string 'paid'
    t.datetime 'billing_date'
    t.integer 'cost'
    t.integer 'cc_number'
    t.integer 'cc_expiration'
    t.integer 'cc_code'
    t.datetime 'created_at'
    t.datetime 'updated_at'
    t.string 'payment_id'
    t.index ['user_id'], name: 'index_subscriptions_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end
end
