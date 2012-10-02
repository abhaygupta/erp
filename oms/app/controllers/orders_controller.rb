class OrdersController < ApplicationController

  def index
    Rails.logger.info "Search for orders with params: #{params}"
    limit = params.delete(:limit) || 100
    offset = params.delete(:offset) || 0
    @orders = Order.where(params).offset(offset).limit(limit)
  end
end
