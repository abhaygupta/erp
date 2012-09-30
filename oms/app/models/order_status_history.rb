class OrderStatusHistory < ActiveRecord::Base
  belongs_to :order

  attr_accessible :order_id, :status_time, :from_status, :to_status, :event, :change_reason, :comments,
                  :created_by

  validates_presence_of :order_id, :status_time, :to_status
  validates_length_of :from_status, :to_status, :maximum => 20
  validates_length_of :created_by, :maximum => 50, :allow_nil => true, :allow_blank => true
  validates_length_of :event, :change_reason, :maximum => 100, :allow_nil => true, :allow_blank => true
  validates_length_of :comments, :maximum => 1000, :allow_nil => true, :allow_blank => true
end
