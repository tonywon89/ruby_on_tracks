require 'json'

class Session

  attr_reader :cookies
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    json_cookies = req.cookies['_rails_lite_app'] || {}.to_json
    parsed_cookies = JSON.parse(json_cookies)
    @cookies = parsed_cookies
  end

  def [](key)
    cookies[key]
  end

  def []=(key, val)
    cookies[key] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie(
      '_rails_lite_app',
      {
        path: '/',
        value: cookies.to_json
      }
    )
  end
end
