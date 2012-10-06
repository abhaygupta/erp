require File.expand_path(File.dirname(__FILE__) + '/../../test/test_helper.rb')

class RouteFlowsTest < ActionDispatch::IntegrationTest
  #fixtures :all

  context "should test order controllers routes" do
    setup do
      Order.delete_all
      OrderStatusHistory.delete_all
      create_order
    end

    should "test create order" do
      post "/orders", FactoryGirl.attributes_for(:order)
      assert_equal 201, @response.status
      assert_not_nil JSON.parse(@response.body)["order"]
    end

    should "test get call order call" do
      get "/orders"
      assert_response :success
      assert_equal 200, @response.status
      response_body = JSON.parse(@response.body)
      assert_not_nil response_body['orders']
      #assert_equal @order, response_body['orders'].first
      assert_equal 1, response_body['count']
      assert_equal 1, response_body['total']
      assert_generates "/orders", {:controller => "orders", :action => "index"}
    end

    should "test get call by order id call" do
      get "/orders/#{@order['id']}"
      assert_equal 200, @response.status
      response_body = JSON.parse(@response.body)
      assert_not_nil response_body['order']
      #assert_equal @order, response_body['order']
      assert_generates "/orders/#{@order['id']}", {:controller => "orders", :action => "show", :id => @order['id']}
    end

    should "test create a new order object" do
      order_params = FactoryGirl.attributes_for(:order)
      get "/orders/new", order_params
      assert_not_nil assigns(:order)
      assert assigns(:order).kind_of?(Order)
      assert assigns(:order).new_record?
      assert_generates "/orders/new", {:controller => "orders", :action => "new"}
    end

    should "test edit order by id call" do
      get "/orders/#{@order['id']}/edit", {:status=>'cancelled'}
      assert_equal 204, @response.status
      order = Order.find(@order['id'])
      assert order.cancelled?
      assert_generates "/orders/#{@order['id']}/edit", {:controller => "orders", :action => "edit", :id => @order['id']}
    end

    should "test update order by id call" do
      put "/orders/#{@order['id']}", {:status=>'cancelled'}
      assert_equal 204, @response.status
      order = Order.find(@order['id'])
      assert order.cancelled?
      assert_generates "/orders/#{@order['id']}", {:controller => "orders", :action => "update", :id => @order['id']}
    end

    should "test destroy order by id call" do
      delete "/orders/#{@order['id']}"
      assert_equal 204, @response.status
      assert_raises(ActiveRecord::RecordNotFound) { Order.find(@order['id']) }
    end
  end

    def create_order
      post "/orders", FactoryGirl.attributes_for(:order)
      assert_equal 201, @response.status
      @order = JSON.parse(@response.body)["order"]
      assert_equal 1, Order.count
    end
  end
