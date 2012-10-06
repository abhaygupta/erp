class OrderAssoc < ActiveRecord::Base

  belongs_to :from_order, class_name: 'Order'
  belongs_to :to_order, class_name: 'Order'

  attr_accessible :from_order_id, :to_order_id, :assoc_type
  validates_presence_of :from_order_id, :to_order_id, :assoc_type
  validates_length_of :assoc_type, :maximum => 20
  validates_inclusion_of :assoc_type, :in => %w(duplicate)
end
