class ApplicationController < ActionController::Base
  rescue_from Exception, :with => :error_render_method

  include ApplicationHelper
  include OrdersHelper
  protect_from_forgery


  protected
  def error_render_method
    respond_to do |type|
      type.html { render :template => "errors/error_404", :status => 404 }
      type.all { render :nothing => true, :status => 404 }
    end
    true
  end
end
