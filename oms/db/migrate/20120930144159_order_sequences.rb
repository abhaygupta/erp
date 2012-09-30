class OrderSequences < ActiveRecord::Migration
  def change
    create_table :order_sequences, :id => false do |t|
      t.string :seq_id, :limit => 100, :null => false
    end
  end
end
