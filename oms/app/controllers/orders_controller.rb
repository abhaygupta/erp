class OrdersController < ApplicationController

  def index
    Rails.logger.info "Search for orders with params: #{params}"
    limit = params.delete(:limit) || 100
    offset = params.delete(:offset) || 0
    @orders = Order.where(accept_params(params, %w(id external_id channel status customer_id phone email_id pickup_address_id drop_address_id billing_address_id))).offset(offset).limit(limit)
  end

end
