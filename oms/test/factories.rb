FactoryGirl.define do
  sequence :random_number do |i|
    "%010d" % i
  end

  sequence :cur_date do
    time = Time.new + 60 * 60 * 24
    time.strftime("%Y-%m-%d %H:%M:%S")
  end

  factory :order do
    external_id { "test-od-#{FactoryGirl.generate(:random_number)}" }
    channel "website"
    order_date { FactoryGirl.generate(:cur_date) }
    created_by { "test-user-#{FactoryGirl.generate(:random_number)}" }
    currency "INR"
    billing_amount 1000.00
    customer_id { FactoryGirl.generate(:random_number) }
    pickup_address_id { FactoryGirl.generate(:random_number) }
    drop_address_id { FactoryGirl.generate(:random_number) }
    billing_address_id { FactoryGirl.generate(:random_number) }
    status "created"
  end

end
