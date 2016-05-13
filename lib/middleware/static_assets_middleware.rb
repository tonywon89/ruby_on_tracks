class StaticAssetsMiddleware
  attr_reader :app

  MIME_TYPES = ["jpg", "jpeg", "gif", "js"]

  def initialize(app)
    puts "Initializing Static Assests Middleware..."
    @app = app
  end

  def call(env)
    puts "Calling Static Assets Middleware..."
    req = Rack::Request.new(env)
    res = Rack::Response.new

    mime_type = req.path.scan(/\w+$/).first

    if MIME_TYPES.include?(mime_type)
      file_path ="public#{req.path}"
      file = File.read(file_path)

      res['Content-type'] = mime_type
      res.write(file)
      res.finish
    else
      app.call(env)
    end
  end

end
