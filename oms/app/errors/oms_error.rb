class OMSError < StandardError

  attr_reader :code, :type, :message, :params

  def initialize(code='OMS_UNKNOWN_ERROR', message="Unkown error happened", type="ERROR", params={})
    @code = code
    @type = type
    @message = message
    @params = params
  end
end