require File.expand_path(File.dirname(__FILE__) + '/../../test/test_helper.rb')

class OrdersControllerTest < ActionController::TestCase

  context "search order test" do
    setup do
      @order = FactoryGirl.create :order
    end

    should "test search orders without any params" do
      get(:index)
      assert_not_nil assigns(:orders)
    end
  end
end

