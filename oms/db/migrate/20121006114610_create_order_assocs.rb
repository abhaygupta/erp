class CreateOrderAssocs < ActiveRecord::Migration
  def change
    create_table :order_assocs do |t|
      t.column :from_order_id, :bigint, :null=>false
      t.column :to_order_id, :bigint, :null=>false
      t.string :assoc_type, :limit=>20, :null=>false
      t.timestamps
    end
  end
end
