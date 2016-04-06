
class Flash

  attr_reader :cookies, :req, :res

  def initialize(req, res)
    @req = req
    @res = res
    json_cookies = req.cookies['_flash_cookie']
    @cookies = json_cookies ? JSON.parse(json_cookies) : {}
    reset_flash
  end

  def [](key)
    cookies[key.to_s]
  end

  def []=(key, value)
    cookies[key.to_s] = value
    store_flash(cookies.to_json)
  end

  def reset_flash
    store_flash({})
  end

  def store_flash(value)
    res.set_cookie(
      '_flash_cookie',
      {
        path: '/',
        value: value
      }
    )
  end
end
