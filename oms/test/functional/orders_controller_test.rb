require File.expand_path(File.dirname(__FILE__) + '/../../test/test_helper.rb')

class OrdersControllerTest < ActionController::TestCase

  context "search order test" do
    setup do
      Order.delete_all
      OrderStatusHistory.delete_all
      @order = FactoryGirl.create :order
      get :index
    end

    should "test search orders without any params" do
      assert_equal 200, @response.status
      response_body = JSON.parse(@response.body)
      assert response_body["orders"].present?
      assert response_body["total"].present?
      assert response_body["count"].present?
      result = response_body["orders"]
      assert_equal @order.id, result.first["id"]
      assert_equal 1, response_body["total"]
      assert_equal 1, response_body["count"]
    end
  end

  context "create order test" do
    setup do
      post :create, FactoryGirl.attributes_for(:order)
    end

    should "test order creation" do
      assert_equal 201, @response.status
      response_body = JSON.parse(@response.body)
      order = response_body["order"]
      assert_not_nil order
      assert_equal "/orders/#{order['id']}", @response.header["Location"]
      assert_equal 1, OrderStatusHistory.where(:order_id=> order['id']).count
    end
  end
end

