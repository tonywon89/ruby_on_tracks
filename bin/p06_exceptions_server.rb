require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'
require_relative '../lib/exception_middleware'

class MyController < ControllerBase
  def go
    render :non_existent_view
  end
end

error_app = Proc.new do |env|
  puts "calling error app"
  req = Rack::Request.new(env)
  res = Rack::Response.new

  MyController.new(req, res).go

  res.finish
end

middleware_app = Rack::Builder.new do
  use ExceptionMiddleware
  run error_app
end.to_app

Rack::Server.start(
  app: middleware_app,
  Port: 3000
)
