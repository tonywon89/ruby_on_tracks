require 'rack'
require_relative '../lib/static_assets_middleware'

dummy_app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new

  res.finish

end

app = Rack::Builder.new do
  use StaticAssetsMiddleware
  run dummy_app
end.to_app

Rack::Server.start(
  app: app,
  Port: 3000
)
