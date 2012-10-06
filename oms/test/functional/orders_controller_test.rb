require File.expand_path(File.dirname(__FILE__) + '/../../test/test_helper.rb')

class OrdersControllerTest < ActionController::TestCase

  def setup
    Order.delete_all
    OrderStatusHistory.delete_all
  end

  context "search order test" do
    setup do
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
      assert_equal 1, OrderStatusHistory.where(:order_id => order['id']).count
    end
  end

  context "get order by id" do
    setup do
      post :create, FactoryGirl.attributes_for(:order)
      assert_equal 201, @response.status
      response_body = JSON.parse(@response.body)
      @order = response_body["order"]
    end

    should "test search order by id success" do
      get :show, @order
      assert_equal 200, @response.status
      response_body = JSON.parse(@response.body)
      assert_not_nil response_body["order"]
    end

    should "test search order by id fails" do
      get :show, {:id=>"0000000000"}
      assert_equal 404, @response.status
    end
  end

  context "should create new order object" do
    setup do
      get :new, FactoryGirl.attributes_for(:order)
    end

    should "check newly order object" do
      assert_not_nil assigns(:order)
      assert assigns(:order).kind_of?(Order)
      assert assigns(:order).new_record?
    end
  end

  context "should edit a order" do
    setup do
      post :create, FactoryGirl.attributes_for(:order)
      assert_equal 201, @response.status
      response_body = JSON.parse(@response.body)
      @order = response_body["order"]
    end

    should "update some attributes" do
      get :edit, {:id=> @order['id'], :status=>'completed'}
      assert_equal 204, @response.status
      assert Order.find(@order['id']).completed?
    end
  end

  context "should update a order" do
    setup do
      post :create, FactoryGirl.attributes_for(:order)
      assert_equal 201, @response.status
      response_body = JSON.parse(@response.body)
      @order = response_body["order"]
    end

    should "update some attributes" do
      put :update, {:id=> @order['id'], :status=>'completed'}
      assert_equal 204, @response.status
      assert Order.find(@order['id']).completed?
    end
  end

  context "should destroy the order" do
    setup do
      post :create, FactoryGirl.attributes_for(:order)
      assert_equal 201, @response.status
      response_body = JSON.parse(@response.body)
      @order = response_body["order"]
    end

    should "delete order" do
      delete :destroy, {:id=> @order['id']}
      assert_equal 204, @response.status
      assert_raises(ActiveRecord::RecordNotFound) { Order.find(@order['id']) }
    end
  end
end

