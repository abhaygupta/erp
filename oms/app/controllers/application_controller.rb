class ApplicationController < ActionController::Base
  rescue_from Exception, :with => :error_render_method

  include ApplicationHelper
  include OrdersHelper
  protect_from_forgery

  protected
  def error_render_method
    json_status 404, OMSError.new(404, "RECORD_NOT_FOUND", $!.message || "Record not found") if $!.kind_of? ActiveRecord::RecordNotFound
    json_status 400, OMSError.new(400, "RECORD_INVALID", $!.message || "Record invalid") if $!.kind_of?(ActiveRecord::RecordInvalid)
    json_status 400, OMSError.new(400, "STATEMENT_INVALID", $!.message || "Statement invalid") if $!.kind_of?(ActiveRecord::StatementInvalid)
    json_status 400, OMSError.new(400, "JSON_PARSE_ERROR", $!.message || "JSON parsing error") if $!.kind_of?(JSON::ParserError)
    json_status 400, OMSError.new(400, "RECORD_NOT_SAVED", $!.message || "Record not saved") if $!.kind_of?(ActiveRecord::RecordNotSaved)
    json_status 400, OMSError.new(400, "UNKOWN_ATTR", $!.message || "Unknown attribute") if $!.kind_of?(ActiveRecord::UnknownAttributeError)
    json_status 409, OMSError.new(409, "STALE_OBJECT", $!.message || "Stale Object") if $!.kind_of?(ActiveRecord::StaleObjectError)
    json_status 400, OMSError.new(400, "INVALID_STATE_TXN", $!.message || "Invalid State txn") if $!.kind_of?(StateMachine::InvalidTransition)
    json_status 400, OMSError.new(400, "REST_CLIENT_ERROR", $!.message || "Rest client exception") if $!.kind_of?(RestClient::Exception)
    json_status 503, OMSError.new(503, "CONNECTION_REFUSED", $!.message || "Error connection refused") if $!.kind_of?(Errno::ECONNREFUSED)
    json_status 503, OMSError.new(503, "HOST_UNREACHABLE", $!.message || "Error host unreachable") if $!.kind_of?(Errno::EHOSTUNREACH)
  end
end
