class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :external_id, :limit=> 100, :null=> false
      t.string :channel, :limit=> 20, :default=> 'website'
      t.string :status, :limit=> 20, :default=> 'created'
      t.string :currency, :limit=> 20, :default=> 'INR'
      t.decimal :billing_amount, :default=> 0.00, :precision=> 2
      t.datetime :order_date, :null=>false
      t.datetime :pickup_time, :null=>false
      t.string :customer_id, :limit=> 100, :null=> false
      t.string :phone, :limit=> 100
      t.string :email_id, :limit=> 100
      t.string :pickup_address_id, :limit=> 100, :null=> false
      t.string :drop_address_id, :limit=> 100, :null=> false
      t.string :billing_address_id, :limit=> 100, :null=> false
      t.string :created_by, :limit=> 50, :default=> 'website'
      t.string :comments, :limit=> 1000
      t.timestamps
    end
  end
end
