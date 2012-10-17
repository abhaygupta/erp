class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.column :order_id, :bigint, :null=> false
      t.string :currency, :limit=> 20, :default=> 'INR'
      t.string :status, :limit=> 20, :default=> 'init'
      t.string :payment_method, :limit=> 20, :null=> false
      t.string :payment_type, :limit=> 20, :null=> false
      t.string :channel, :limit=> 50
      t.string :gateway, :limit=> 50
      t.string :terminal, :limit=> 50
      t.string :ref_num, :limit=> 50
      t.datetime :payment_date, :null=>false
      t.string :external_id, :limit=> 50
      t.boolean :fraud, :default => false
      t.string :party_id_to, :limit=> 100, :null=> false #payment received by
      t.string :party_id_from, :limit=> 100, :null=> false #payment made by
      t.decimal :paid_amount, :default=> 0.00, :precision=> 2
      t.decimal :promised_amount, :default=> 0.00, :precision=> 2
      t.string :comments, :limit=> 1000
      t.string :created_by, :limit=> 50, :default=> 'website'
      t.timestamps
    end
  end
end
