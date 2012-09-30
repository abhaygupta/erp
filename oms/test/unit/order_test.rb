require File.expand_path(File.dirname(__FILE__) + '/../../test/test_helper.rb')

class OrderTest < ActiveSupport::TestCase

  context "test order model validations" do

    [:external_id, :order_date, :customer_id, :pickup_address_id, :drop_address_id, :billing_address_id].each { |column| should validate_presence_of(column) }
    [:external_id, :customer_id, :phone, :email_id, :pickup_address_id, :drop_address_id, :billing_address_id].each { |column| should ensure_length_of(column).is_at_most(100) }
    [:channel, :status, :currency].each { |column| should ensure_length_of(column).is_at_most(20) }
    should ensure_length_of(:created_by).is_at_most(50)
    should ensure_length_of(:comments).is_at_most(1000)

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
  end
end
