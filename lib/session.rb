require 'json'

class Session

  attr_reader :cookies
  # find the cookie for this app
  # deserialize the cookie into a hash
  def initialize(req)
    json_cookies = req.cookies['_session_cookie']
    @cookies = json_cookies ? JSON.parse(json_cookies) : {}
  end

  def [](key)
    cookies[key.to_s]
  end

  def []=(key, val)
    cookies[key.to_s] = val
  end

  # serialize the hash into json and save in a cookie
  # add to the responses cookies
  def store_session(res)
    res.set_cookie(
      '_session_cookie',
      {
        path: '/',
        value: cookies.to_json
      }
    )
  end
end
