require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'

$cats = [
  { id: 1, name: "Curie" },
  { id: 2, name: "Markov" }
]

$statuses = [
  { id: 1, cat_id: 1, text: "Curie loves string!" },
  { id: 2, cat_id: 2, text: "Markov is mighty!" },
  { id: 3, cat_id: 1, text: "Curie is cool!" }
]

class StatusesController < ControllerBase
  def index
    statuses = $statuses.select do |s|
      s[:cat_id] == Integer(params['cat_id'])
    end

    render_content(statuses.to_json, "application/json")
  end
end

class CatsController < ControllerBase

  def index
    render_content($cats.to_json, "application/json")
  end

  def create_flash
    flash[:stay_one_cycle] = "This Flash lasts for one cycle."
    flash.now[:will_not_show] = "Will not show this flash because it expires."
    redirect_to "http://localhost:3000/cats/1"
  end

  def show
    flash.now[:temp_flash] = "This flash will only show on the show page."
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/cats$"), CatsController, :index
  get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
  get Regexp.new("^/cats/(?<id>\\d+)$"), CatsController, :show
  get Regexp.new("^/cats/create_flash$"), CatsController, :create_flash
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)
