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

    Order.transaction do
      @order = build_order(params)
      @order.save!
    end

    Rails.logger.info "Order id #{@order.id} created successfully"
    render :json => {:order => @order}.to_json, :status => 201, :location => order_path(@order)
  end

  def show
    Rails.logger.info "Get order called with params : #{params}"

    @order = Order.find(params[:id])
    render :json => {:order => @order}.to_json, :status => 200
  end

  def new
    Rails.logger.info "New order called with params : #{params}"
    build_order(params)
  end

  def edit
    Rails.logger.info "Edit order called with params : #{params}"
    @order = Order.find(params[:id])

  end

end
