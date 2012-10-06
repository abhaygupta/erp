class Order < ActiveRecord::Base

  has_many :order_status_histories, :dependent => :delete_all, :autosave => true
  has_many :call_verifications, :dependent => :delete_all, :autosave => true
  has_many :order_assoc_to, class_name: 'OrderAssoc', :foreign_key => :to_order_id, :autosave => true
  has_many :order_assoc_from, class_name: 'OrderAssoc', :foreign_key => :from_order_id, :autosave => true

  attr_accessible :external_id, :channel, :status, :currency, :billing_amount, :order_date, :customer_id,
                  :phone, :email_id, :address_id, :pickup_address_id, :drop_address_id, :billing_address_id, :created_by, :comments

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
      order.log_state_change(transition.from, transition.to, transition.event.to_s, args[:status_time] || Time.new, args[:change_reason], args[:comments])
    end

    #after_transition :on => :approve, :do => :check_duplicate

    event :approve do
      transition [:created, :on_hold] => :approved
    end

    event :cancel do
      transition [:created, :on_hold, :approved] => :cancelled
    end

    event :complete do
      transition :approved => :completed
    end

    event :hold do
      transition [:created, :approved] => :on_hold
    end
  end

  def ever_approved?
    order_status_histories.where(to_status: 'approved').any?
  end

  def check_duplicate
    duplicate_orders = duplicates
    if duplicate_orders.present?
      Order.transaction do
        hold!({:change_reason => 'duplicate', :comments => "Order duplicate for following orders #{duplicate_orders.collect(&:id).join(",")}"})
        duplicate_orders.each {|order| self.order_assoc_to << OrderAssoc.new(:from_order_id => order.id, :assoc_type => 'duplicate')}
        save!
      end
    end
  end

  def duplicates
    Order.where(:customer_id => self.customer_id, :status => %w(approved on_hold))
  end

  def log_state_change(from_status, to_status, event, status_time= Time.now, change_reason = nil, comments = nil)
    order_status_histories.create!(order_id: self.id, status_time: status_time, from_status: from_status,
                                   to_status: to_status, event: event, change_reason: change_reason, comments: comments, created_by: 'system')
  end
end
