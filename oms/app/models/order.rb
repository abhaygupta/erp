class Order < ActiveRecord::Base

  has_many :order_status_histories, :dependent => :delete_all, :autosave => true

  attr_accessible :external_id, :channel, :status, :currency, :billing_amount, :order_date, :customer_id,
                  :phone, :email_id, :address_id, :drop_address_id, :billing_address_id, :created_by, :comments

  validates_presence_of :external_id, :order_date, :customer_id, :pickup_address_id, :drop_address_id, :billing_address_id
  validates_length_of :external_id, :customer_id, :phone, :email_id, :pickup_address_id, :drop_address_id, :billing_address_id, :maximum => 100
  validates_length_of :channel, :status, :currency, :maximum => 20
  validates_length_of :created_by, :maximum => 50, :allow_nil => true, :allow_blank => true
  validates_length_of :comments, :maximum => 1000

  validates_inclusion_of :channel, :in => %w(website mobile email), :allow_nil => true, :allow_blank => true
  validates_inclusion_of :status, :in => %w(created on_hold approved cancelled completed), :allow_nil => true, :allow_blank => true
  validates_inclusion_of :currency, :in => %w(INR USD), :allow_nil => true, :allow_blank => true

  state_machine :status, :initial => :created do

    before_transition do |order, transition|
      args = transition.args[0]
      args ||= {}
      order.log_state_change(transition.from, transition.to, transition.event.to_s, args[:status_time], args[:change_reason], args[:comments])
    end

    event :approve do
      transition [:created, :on_hold] => :approved
    end

    event :cancel do
      transition [:created, :on_hold] => :cancelled
    end

    event :complete do
      transition :approved => :completed
    end

    event :hold do
      transition [:created, :approved] => :on_hold
    end
  end

  def log_state_change(from_status, to_status, event, status_time = Time.new, change_reason = nil, comments = nil)
    order_status_histories.create!(order_id: self.id, status_time: status_time, from_status: from_status,
                                   to_status: to_status, event: event, change_reason: change_reason, comments: comments, created_by: 'website')
  end
end
