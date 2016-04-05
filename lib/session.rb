require 'json'

class Session

  attr_reader :session
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    json_cookies = req.cookies['_rails_lite_app']
    parsed_cookies = JSON.parse(json_cookies)
    @session =  parsed_cookies
  end

  def [](key)
    session[key]
  end

  def []=(key, val)
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
  end
end
