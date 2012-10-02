module OrdersHelper

  def build_order(params)
    order = Order.new(accept_params(params, %w(external_id channel currency billing_amount order_date customer_id phone email_id pickup_address_id drop_address_id billing_address_id created_by comments)))
    order.order_date ||= Time.now.strftime("%d-%m-%Y %H:%M:%S")
    order.external_id ||= generate_external_id
    order.order_status_histories << build_order_status_history(order)
    order
  end

  def build_order_status_history(order)
    OrderStatusHistory.new(:status_time => order.order_date || Time.now.strftime("%d-%m-%Y %H:%M:%S"), :to_status => 'created', :event => 'created', :change_reason => 'order created', :created_by => order.created_by || 'system')
  end

  def generate_external_id
    time = Time.now
    prefix = Rails.application.config.order_prefix + (time.year % 10).to_s + time.strftime('%d') + time.strftime('%m') + time.strftime('%H')
    random_number = "%05d" % Order.connection.insert("insert into order_sequences values('" + prefix + "')")
    prefix + shift(random_number, 4).to_s
  end

  def shift(string, count)
    arr = string.split('')
    count.times do
      arr << arr.shift
    end
    arr.join
  end
end
