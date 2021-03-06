require File.expand_path(File.dirname(__FILE__) + '/../../test/test_helper.rb')

class OrderStatusHistoryTest < ActiveSupport::TestCase

  context "test order status history model validations" do
    [:order_id, :status_time, :from_status, :to_status, :event, :change_reason, :comments,
     :created_by].each { |column| should allow_mass_assignment_of(column) }
    [:status_time, :to_status].each { |column| should validate_presence_of(column) }
    [:from_status, :to_status].each { |column| should ensure_length_of(column).is_at_most(20) }
    should ensure_length_of(:created_by).is_at_most(50)
    [:event, :change_reason].each { |column| should ensure_length_of(column).is_at_most(100) }
    should ensure_length_of(:comments).is_at_most(1000)

    %w(created on_hold approved cancelled completed).each do |value|
      should allow_value(value).for(:from_status)
      should allow_value(value).for(:to_status)
    end

    should belong_to(:order)
  end

end
