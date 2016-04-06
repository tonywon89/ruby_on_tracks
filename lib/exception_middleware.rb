class ExceptionMiddleware
  attr_reader :app

  def initialize(app)
    puts "Initializing ExceptionMiddleware"
    @app = app
  end

  def call(env)

    res = Rack::Response.new

    puts "Calling ExceptionMiddleware"
    begin
      app.call(env)
    rescue => e

      puts e.message
      res['Content-Type'] = 'text/html'
      file = File.read('views/errors/error.html.erb')
      error_template = ERB.new(file).result(binding)
      res.write(error_template)
      res.finish
    end
  end
end
