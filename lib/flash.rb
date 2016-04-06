
class Flash

  attr_reader :cookies, :req, :res, :now_instance, :temp_cookies

  def initialize(req, res, now_instance = false)
    @req, @res, @now_instance = req, res, now_instance

    if @now_instance
      @temp_cookies = {}
    else
      json_cookies = req.cookies['_flash_cookie']
      @cookies = json_cookies ? JSON.parse(json_cookies) : {}
      reset_flash
    end
  end

  def [](key)
    cookies.merge(now.temp_cookies)[key.to_s]
  end

  def []=(key, value)
    if now_instance
      temp_cookies[key.to_s] = value
    else
      cookies[key.to_s] = value
      store_flash(cookies.to_json)
    end
  end

  def reset_flash
    store_flash({})
  end

  def now
    @now ||= Flash.new(req, res, true)
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
