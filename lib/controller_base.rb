require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'
require_relative './flash'


class ControllerBase
  attr_reader :req, :res, :params

  include SecureRandom

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = req.params.merge(route_params)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise if already_built_response?

    res.status = 302
    res['Location'] = url
    @already_built_response = true

    session.store_session(res)
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type)
    raise if already_built_response?

    res['Content-Type'] = content_type
    res.write(content)

    @already_built_response = true

    session.store_session(res)
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    file_path = "views/#{self.class.name.underscore}/#{template_name}.html.erb"
    lines = File.read(file_path)
    template = ERB.new(lines)
    result = template.result(binding)

    render_content(result, 'text/html')
  end

  # method exposing a `Session` object
  def session
    @session ||= Session.new(req)
  end

  def flash
    @flash ||= Flash.new(req, res)
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    send(name)
    render(name) unless already_built_response?
  end

  def form_authenticity_token
    token = SecureRandom.urlsafe_base64(16)
    session[:csrf] = token
    session.store_session(res)
  end

  def self.protect_from_forgery
    unless req.get?
      form_auth_token = req.params["authenticity_token"]
      raise unless session[:csrf] == form_auth_token
    end
  end
end
