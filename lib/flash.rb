
class Flash

  attr_reader :cookies, :req, :res

  def initialize(req, res)
    @req = req
    @res = res
    json_cookies = req.cookies['_flash_cookie']
    @cookies = json_cookies ? JSON.parse(json_cookies) : {}
    remove_flash
  end

  def [](key)
    cookies[key]
  end

  def []=(key, value)
    cookies[key] = value
    store_flash
  end

  def remove_flash
    res.set_cookie(
      '_flash_cookie',
      {
        path: '/',
        value: {}
      }
    )
  end

  def store_flash
    res.set_cookie(
      '_flash_cookie',
      {
        path: '/',
        value: cookies.to_json
      }
    )
  end
end
