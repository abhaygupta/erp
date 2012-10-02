module OrdersHelper

  def generate_external_id
    time = Time.now
    prefix = settings.order_id_prefix + (time.year % 10).to_s + time.strftime('%d') + time.strftime('%m') + time.strftime('%H')
    random_number = "%05d" % Order.connection.insert("insert into order_sequences values('" + prefix + "', null)")
    prefix + shift(random_number, 4).to_s
  end
end
