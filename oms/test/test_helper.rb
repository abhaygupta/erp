ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require File.expand_path(File.dirname(__FILE__) + "/factories")
require 'rails/test_help'
require 'mocha'
require 'pp'
require 'test/unit'
require 'active_record/fixtures'


class ActiveSupport::TestCase
  include Mocha::API
  include Rack::Test::Methods
  include ActiveRecord::TestFixtures

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

