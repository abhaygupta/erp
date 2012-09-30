class CreateOrderStatusHistories < ActiveRecord::Migration
  def change
    create_table :order_status_histories do |t|
      t.column :order_id, :bigint, :null=>false
      t.datetime :status_time, :null=>false
      t.string :from_status, :limit=>20
      t.string :to_status, :limit=>20, :null=>false
      t.string :event, :limit=>100
      t.string :change_reason, :limit=>100
      t.string :comments, :limit=>1000
      t.string :created_by, :limit=> 50, :default=> 'website'
      t.timestamps
    end
  end
end
