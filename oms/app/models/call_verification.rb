class CallVerification < ActiveRecord::Base
  belongs_to :order

  VERIFICATION_TYPES = %w(cod duplicate fraud blacklisted_customer)
  VERIFICATION_REASONS = %w(cod_order duplicate_order fraud_payment blacklisted_customer)

  attr_accessible :order_id, :status, :reason, :verification_type, :comments, :created_by
  validates_presence_of :reason, :verification_type
  validates_length_of :comments, :maximum => 1000, :allow_blank => true, :allow_nil => true
  validates_length_of :reason, :verification_type, :maximum => 100
  validates_length_of :status, :maximum => 20
  validates_length_of :created_by, :maximum => 50
  validates_inclusion_of :status, :in => %w(init pending approved declined), :allow_nil => true, :allow_blank => true
  validates_inclusion_of :verification_type, :in => VERIFICATION_TYPES
  validates_inclusion_of :reason, :in => VERIFICATION_REASONS

  state_machine :status, :initial => :init do
    after_transition do |call_verification, transition|
      call_verification.update_order(transition)
    end

    event :approve do
      transition [:init, :pending] => :approved
    end

    event :decline do
      transition [:init, :pending] => :declined
    end

    event :pending do
      transition :init => :pending
    end
  end

  VERIFICATION_TYPES.each do |type|
    define_method "#{type}_verification?" do
      type == self.verification_type
    end
  end

  def update_order
    Rails.logger.info "Updating order for call verification transition from: #{transition.try(:from)}, to: #{transition.try(:to)}"
    CallVerification.transaction do
      order.approve! if approved?
      order.cancel! if declined?
    end
  end
end
