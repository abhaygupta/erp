module ApplicationHelper

  def accept_params(params, fields)
    h = { }
    fields.each do |name|
      h[name] = params[name] if params[name]
    end
    h
  end
end
