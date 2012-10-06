class OrdersController < ApplicationController

  def index
    Rails.logger.info "Search for orders with params: #{params}"
    limit = params[:limit] || 100
    offset = params[:offset] || 0

    search_params = accept_params(params, %w(id external_id channel status customer_id phone email_id pickup_address_id drop_address_id billing_address_id))
    @orders = Order.where(search_params).offset(offset).limit(limit)
    @total = Order.where(search_params).count
    @count = @orders.size
    render :json => {:orders => @orders, :total => @total, :count => @count}.to_json, :status => 200
  end

  def create
    Rails.logger.info "Create order called with params : #{params}"

    order = nil
    Order.transaction do
      order = build_order(params)
      order.save!
    end

    Rails.logger.info "Order id #{order.id} created successfully"
    render :json => {:order => order}.to_json, :status => 201, :location => order_path(order)
  end

  def show
    Rails.logger.info "Get order called with params : #{params}"
    order = Order.find(params[:id])
    render :json => {:order => order}.to_json, :status => 200
  end

  def new
    Rails.logger.info "New order called with params : #{params}"
    @order = build_order(params)
  end

  def edit
    Rails.logger.info "Edit order called with params : #{params}"
    order = Order.find(params[:id])
    update_attributes = accept_params(params, %w(id external_id channel status customer_id phone email_id pickup_address_id drop_address_id billing_address_id))
    Rails.logger.info "Updating attributes for order #{order.id} , attributes : #{update_attributes}"
    Order.transaction do
      order.update_attributes(update_attributes)
    end
    render :status => 204
  end

  def update
    Rails.logger.info "Update order called with params : #{params}"
    order = Order.find(params[:id])
    update_attributes = accept_params(params, %w(id external_id channel status customer_id phone email_id pickup_address_id drop_address_id billing_address_id))
    Rails.logger.info "Updating attributes for order #{order.id} , attributes : #{update_attributes}"
    Order.transaction do
      order.update_attributes(update_attributes)
    end
    render :status => 204
  end

  def destroy
    Rails.logger.info "Deleting order called with params : #{params}"
    order = Order.find(params[:id])
    Order.transaction do
      Order.delete(order)
    end
    render :status => 204
  end

  def approve
    Rails.logger.info "Approve order called with params : #{params}"
    order = Order.find(params[:id])
    Order.transaction do
      order.approve!
    end
    render :status => 204
  end

  def cancel
    Rails.logger.info "Cancel order called with params : #{params}"
    order = Order.find(params[:id])
    Order.transaction do
      order.cancel!
    end
    render :status => 204
  end

  def hold
    Rails.logger.info "Hold order called with params : #{params}"
    order = Order.find(params[:id])
    Order.transaction do
      order.hold!
    end
    render :status => 204
  end

  def complete
    Rails.logger.info "Complete order called with params : #{params}"
    order = Order.find(params[:id])
    Order.transaction do
      order.complete!
    end
    render :status => 204
  end
end
