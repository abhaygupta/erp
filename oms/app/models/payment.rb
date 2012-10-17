class Payment < ActiveRecord::Base

  attr_accessible :order_id, :status, :payment_method, :payment_type, :channel, :currency, :gateway, :terminal, :ref_num, :payment_date,
                  :external_id, :fraud, :party_id_to, :party_id_from, :paid_amount, :promised_amount, :comments, :created_by

  validates_presence_of :order_id, :payment_method, :payment_type, :payment_date, :party_id_to, :party_id_from
  validates_length_of :status, :payment_method, :payment_type, :currency, :maximum => 20
  validates_length_of :channel, :gateway, :terminal, :ref_num, :external_id, :created_by, :maximum => 50
  validates_length_of :party_id_to, :party_id_from, :maximum => 100
  validates_length_of :comments, :maximum => 1000
  validates_numericality_of :paid_amount, :promised_amount, :greater_than_or_equal_to => 0

  validates_inclusion_of :payment_type, :in => %w(customer_credit customer_payment customer_refund vendor_credit vendor_payment vendor_refund)
  validates_inclusion_of :status, :in => %w(init authorized received cancelled declined settled decline_settled), :allow_blank => true, :allow_nil => true
  validates_inclusion_of :payment_method, :in => %w(cash_on_delivery credit_card debit_card net_banking demand_draft cheque gift_card promotion)
  validates_inclusion_of :currency, :in => %w(INR USD), :allow_nil => true, :allow_blank => true

  state_machine :status, :initial => :init do

    #before_transition do |payment, transition|
    #  args = transition.args[0]
    #  args ||= {}
    #  payment.log_state_change(transition.from, transition.to, transition.event.to_s, args[:status_time] || Time.new, args[:change_reason], args[:comments])
    #end

    event :receive do
      transition [:init, :authorized, :declined] => :received
    end

    event :authorize do
      transition :init => :authorized
    end

    event :cancel do
      transition [:init, :received, :authorized] => :cancelled
    end

    event :decline do
      transition [:init, :authorized, :received] => :declined
    end

    event :settle do
      transition :received => :settled
    end

    event :decline_settle do
      transition :declined => :decline_settled
    end
  end

  def prepaid?
    %w(credit_card debit_card net_banking demand_draft cheque gift_card promotion).include? payment_method
  end

  def cod?
    payment_method == "cash_on_delivery"
  end

  def promotion?
    payment_method == "promotion"
  end

  #def log_state_change(from_status, to_status, event, status_time= Time.now, change_reason = nil, comments = nil)
  #  order_status_histories.create!(order_id: self.id, status_time: status_time, from_status: from_status,
  #                                 to_status: to_status, event: event, change_reason: change_reason, comments: comments, created_by: 'system')
  #end
end
