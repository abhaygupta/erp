class CreateCallVerifications < ActiveRecord::Migration
  def change
    create_table :call_verifications do |t|
      t.column :order_id, :bigint, :null => false
      t.string :status, :limit => 20, :default => 'init'
      t.string :reason, :limit => 100, :null => false
      t.string :verification_type, :limit => 100, :null => false
      t.string :comments, :limit => 1000
      t.string :created_by, :limit => 50
      t.timestamps
    end
  end
end
