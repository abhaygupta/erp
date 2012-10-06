require File.expand_path(File.dirname(__FILE__) + '/../../test/test_helper.rb')

class CallVerificationTest < ActiveSupport::TestCase

  context "test call verification model validations" do

    [:order_id, :status, :reason, :verification_type, :comments, :created_by].each { |column| should allow_mass_assignment_of(column) }
    [:reason, :verification_type].each { |column| should validate_presence_of(column) }
    [:reason, :verification_type].each { |column| should ensure_length_of(column).is_at_most(100) }
    should ensure_length_of(:status).is_at_most(20)
    should ensure_length_of(:created_by).is_at_most(50)
    should ensure_length_of(:comments).is_at_most(1000)

    %w(init pending approved declined).each do |value|
      should allow_value(value).for(:status)
    end

    %w(cod duplicate fraud blacklisted_customer).each do |value|
      should allow_value(value).for(:verification_type)
    end

    %w(cod_order duplicate_order fraud_payment blacklisted_customer).each do |value|
      should allow_value(value).for(:reason)
    end

    should belong_to(:order)
  end

  context "test state change for call verification from init state" do
    setup do
      @verification = FactoryGirl.create(:call_verification, status: 'init')
    end

    should "test state transition from init state" do
      assert @verification.can_approve?
      assert @verification.can_decline?
      assert @verification.can_pending?
    end
  end

  context "test state change for call verification from approve state" do
    setup do
      @verification = FactoryGirl.create(:call_verification, status: 'approved')
    end

    should "test state transition from init state" do
      assert_false @verification.can_approve?
      assert_false @verification.can_decline?
      assert_false @verification.can_pending?
    end
  end

  context "test state change for call verification from declined state" do
    setup do
      @verification = FactoryGirl.create(:call_verification, status: 'declined')
    end

    should "test state transition from init state" do
      assert_false @verification.can_approve?
      assert_false @verification.can_decline?
      assert_false @verification.can_pending?
    end
  end

  context "test state change for call verification from pending state" do
    setup do
      @verification = FactoryGirl.create(:call_verification, status: 'pending')
    end

    should "test state transition from init state" do
      assert @verification.can_approve?
      assert @verification.can_decline?
      assert_false @verification.can_pending?
    end
  end
end
