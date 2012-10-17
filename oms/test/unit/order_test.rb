require File.expand_path(File.dirname(__FILE__) + '/../../test/test_helper.rb')

class OrderTest < ActiveSupport::TestCase

  context "test order model validations" do
    [:external_id, :channel, :status, :currency, :billing_amount, :order_date, :customer_id,
     :phone, :email_id, :address_id, :pickup_address_id, :drop_address_id, :billing_address_id,
     :created_by, :comments, :pickup_time].each { |column| should allow_mass_assignment_of(column) }
    [:external_id, :order_date, :customer_id, :pickup_address_id, :drop_address_id, :billing_address_id, :pickup_time].each { |column| should validate_presence_of(column) }
    [:external_id, :customer_id, :phone, :email_id, :pickup_address_id, :drop_address_id, :billing_address_id].each { |column| should ensure_length_of(column).is_at_most(100) }
    [:channel, :status, :currency].each { |column| should ensure_length_of(column).is_at_most(20) }
    should ensure_length_of(:created_by).is_at_most(50)
    should ensure_length_of(:comments).is_at_most(1000)
    should validate_numericality_of(:billing_amount)

    %w(created on_hold approved cancelled completed).each do |value|
      should allow_value(value).for(:status)
    end

    %w(website mobile email).each do |value|
      should allow_value(value).for(:channel)
    end

    %w(INR USD).each do |value|
      should allow_value(value).for(:currency)
    end

    should have_many(:order_status_histories)
    should have_many(:call_verifications)
  end

  context "should test state transition from created state" do
    setup do
      @order = FactoryGirl.create(:order, status: 'created')
    end

    should "test state transition from created state" do
      assert @order.can_approve?
      assert @order.can_cancel?
      assert @order.can_hold?
      assert_false @order.can_complete?
    end
  end

  context "should test state transition from approved state" do
    setup do
      @order = FactoryGirl.create(:order, status: 'approved')
    end

    should "test state transition from approved state" do
      assert @order.can_cancel?
      assert @order.can_hold?
      assert @order.can_complete?
      assert_false @order.can_approve?
    end
  end

  context "should test state transition from cancelled state" do
    setup do
      @order = FactoryGirl.create(:order, status: 'cancelled')
    end

    should "test state transition from cancelled state" do
      assert_false @order.can_approve?
      assert_false @order.can_hold?
      assert_false @order.can_complete?
      assert_false @order.can_cancel?
    end
  end

  context "should test state transition from on_hold state" do
    setup do
      @order = FactoryGirl.create(:order, status: 'on_hold')
    end

    should "test state transition from on_hold state" do
      assert @order.can_approve?
      assert_false @order.can_hold?
      assert_false @order.can_complete?
      assert @order.can_cancel?
    end
  end

  context "should test state transition from completed state" do
    setup do
      @order = FactoryGirl.create(:order, status: 'completed')
    end

    should "test state transition from completed state" do
      assert_false @order.can_approve?
      assert_false @order.can_hold?
      assert_false @order.can_complete?
      assert_false @order.can_cancel?
    end
  end

  context "should log state transitions" do
    setup do
      @order = FactoryGirl.create(:order, status: 'created')
    end

    should "test state transition logging" do
      assert @order.created?
      assert_equal 0, @order.order_status_histories.count
      @order.approve!
      assert @order.approved?
      assert_equal 1, @order.order_status_histories.count
      @order.hold!
      assert @order.on_hold?
      assert_equal 2, @order.order_status_histories.count
      @order.cancel!
      assert @order.cancelled?
      assert_equal 3, @order.order_status_histories.count
    end
  end

  context "test if order is ever approved" do
    setup do
      @order = FactoryGirl.create(:order, status: 'created')
    end

    should "test order is ever approved" do
      assert @order.created?
      assert_false @order.ever_approved?
      @order.approve!
      assert@order.ever_approved?
    end
  end

  context "should test for duplicates detection" do
    setup do
      @order_1 = FactoryGirl.create(:order, status: 'approved', customer_id: 'customer-1')
      @order_2 = FactoryGirl.create(:order, status: 'approved', customer_id: 'customer-1')
    end

    should "test for duplicates" do
      assert_not_nil @order_1.duplicates
      assert_equal 1, @order_1.duplicates.count
      assert_equal [@order_2], @order_1.duplicates
    end

    should "check for duplicates" do
      @order_1.check_duplicate
      assert @order_1.reload.on_hold?
      assert @order_1.order_assoc_to.present?
      assert_equal @order_1.id, @order_1.order_assoc_to.first.to_order_id
      assert_equal 'duplicate', @order_1.order_assoc_to.first.assoc_type
    end
  end

  context "should test address change" do
    setup do
      @order = FactoryGirl.create(:order)
    end

    should "test change pickup and drop address" do
      @order.change_address({:pickup_address_id=>  "TEST-PICK-UP-ADD", :drop_address_id=> "TEST-DROP-ADD"})
      assert_equal "TEST-PICK-UP-ADD", @order.reload.pickup_address_id
      assert_equal "TEST-DROP-ADD", @order.drop_address_id
    end
  end

end
