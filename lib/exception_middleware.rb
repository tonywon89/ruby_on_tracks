require "byebug"

class ExceptionMiddleware
  attr_reader :app

  def initialize(app)
    puts "Initializing ExceptionMiddleware"
    @app = app
  end

  def call(env)
    puts "Calling ExceptionMiddleware"
    res = Rack::Response.new

    begin
      app.call(env)
    rescue => e
      puts e.message

      top_stack_call = e.backtrace.first.scan(/[^:]+/)

      stack_path = top_stack_call.first
      stack_line = top_stack_call[1].to_i

      stack_file = File.readlines(stack_path)

      range = ((stack_line - 3)..(stack_line + 1))
      surrounding_lines = stack_file[range]

      file = File.read('views/errors/error.html.erb')
      error_template = ERB.new(file).result(binding)

      res['Content-Type'] = 'text/html'
      res.write(error_template)
      res.finish
    end
  end
end
