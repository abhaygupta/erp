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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121016061839) do

  create_table "call_verifications", :force => true do |t|
    t.integer  "order_id",          :limit => 8,                        :null => false
    t.string   "status",            :limit => 20,   :default => "init"
    t.string   "reason",            :limit => 100,                      :null => false
    t.string   "verification_type", :limit => 100,                      :null => false
    t.string   "comments",          :limit => 1000
    t.string   "created_by",        :limit => 50
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  create_table "order_assocs", :force => true do |t|
    t.integer  "from_order_id", :limit => 8,  :null => false
    t.integer  "to_order_id",   :limit => 8,  :null => false
    t.string   "assoc_type",    :limit => 20, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  create_table "order_sequences", :id => false, :force => true do |t|
    t.string "seq_id", :limit => 100, :null => false
  end

  create_table "order_status_histories", :force => true do |t|
    t.integer  "order_id",      :limit => 8,                           :null => false
    t.datetime "status_time",                                          :null => false
    t.string   "from_status",   :limit => 20
    t.string   "to_status",     :limit => 20,                          :null => false
    t.string   "event",         :limit => 100
    t.string   "change_reason", :limit => 100
    t.string   "comments",      :limit => 1000
    t.string   "created_by",    :limit => 50,   :default => "website"
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "external_id",        :limit => 100,                                                       :null => false
    t.string   "channel",            :limit => 20,                                 :default => "website"
    t.string   "status",             :limit => 20,                                 :default => "created"
    t.string   "currency",           :limit => 20,                                 :default => "INR"
    t.decimal  "billing_amount",                     :precision => 2, :scale => 0, :default => 0
    t.datetime "order_date",                                                                              :null => false
    t.datetime "pickup_time",                                                                             :null => false
    t.string   "customer_id",        :limit => 100,                                                       :null => false
    t.string   "phone",              :limit => 100
    t.string   "email_id",           :limit => 100
    t.string   "pickup_address_id",  :limit => 100,                                                       :null => false
    t.string   "drop_address_id",    :limit => 100,                                                       :null => false
    t.string   "billing_address_id", :limit => 100,                                                       :null => false
    t.string   "created_by",         :limit => 50,                                 :default => "website"
    t.string   "comments",           :limit => 1000
    t.datetime "created_at",                                                                              :null => false
    t.datetime "updated_at",                                                                              :null => false
  end

  create_table "payments", :force => true do |t|
    t.integer  "order_id",        :limit => 8,                                                         :null => false
    t.string   "currency",        :limit => 20,                                 :default => "INR"
    t.string   "status",          :limit => 20,                                 :default => "init"
    t.string   "payment_method",  :limit => 20,                                                        :null => false
    t.string   "payment_type",    :limit => 20,                                                        :null => false
    t.string   "channel",         :limit => 50
    t.string   "gateway",         :limit => 50
    t.string   "terminal",        :limit => 50
    t.string   "ref_num",         :limit => 50
    t.datetime "payment_date",                                                                         :null => false
    t.string   "external_id",     :limit => 50
    t.boolean  "fraud",                                                         :default => false
    t.string   "party_id_to",     :limit => 100,                                                       :null => false
    t.string   "party_id_from",   :limit => 100,                                                       :null => false
    t.decimal  "paid_amount",                     :precision => 2, :scale => 0, :default => 0
    t.decimal  "promised_amount",                 :precision => 2, :scale => 0, :default => 0
    t.string   "comments",        :limit => 1000
    t.string   "created_by",      :limit => 50,                                 :default => "website"
    t.datetime "created_at",                                                                           :null => false
    t.datetime "updated_at",                                                                           :null => false
  end

end
