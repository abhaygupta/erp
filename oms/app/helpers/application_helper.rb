module ApplicationHelper

  def accept_params(params, fields)
    h = { }
    fields.each do |name|
      h[name] = params[name] if params[name]
    end
    h
  end

  #def validate_http_request_body(request, symbolize_keys=false)
  #  request.body.rewind
  #  data = request.body.read
  #  raise OMSError.new(:code=> :INVALID_REQUEST_BODY, :messages=> "Invalid request body") if data.blank?
  #  request_data = JSON.parse(data, :symbolize_keys => symbolize_keys)
  #  raise OMSError.new(:code=> :INVALID_REQUEST_BODY, :messages=> "Invalid request body") if request_data.blank?
  #  return request_data
  #end

  def validate_presence_of(params, keys)
    keys.each do |key|
      raise OMSError.new(:code=> :KEY_NOT_FOUND, :params=> {key => params[key]}, :message => "Please pass the param #{key}") if params[key].blank?
    end
  end
end
