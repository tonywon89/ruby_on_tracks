
class Flash

  attr_reader :cookies, :req, :res

  def initialize(req, res)
    @req = req
    @res = res
    json_cookies = req.cookies['_flash_cookie']
    @cookies = json_cookies ? JSON.parse(json_cookies) : {}
    # remove_cookies(res)
  end

  def [](key)
    cookies[key]
  end

  def []=(key, value)
    cookies[key] = value
    store_flash(res)
  end

  def remove_cookies(res)
    res.delete_cookie('_flash_cookies')
  end

  def store_flash(res)
    res.set_cookie(
      '_flash_cookie',
      path: '/', value: cookies.to_json
    )
  end
end
