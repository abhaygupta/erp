class OMSError < StandardError

  attr_reader :code, :type, :message, :params, :http_error_code

  def initialize(http_error_code=400, code='UNKNOWN_ATTR', message="Unkown error", type="ERROR", params={})
    @http_error_code = http_error_code
    @code = code
    @type = type
    @message = message
    @params = params
  end
end