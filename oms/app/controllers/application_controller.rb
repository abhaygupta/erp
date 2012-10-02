class ApplicationController < ActionController::Base
  include ApplicationHelper
  include OrdersHelper
  protect_from_forgery
end
