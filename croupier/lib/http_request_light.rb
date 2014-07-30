
class Croupier::HttpRequestLight

  def initialize(url)
    uri = URI(url)
    @host, @port, @path = uri.host, uri.port, uri.path
  end

  def post(message, &block)
    begin
      try_request(message, &block)
    rescue Exception => e
      yield true, { message: e.message, code: nil } if block_given?
    end
  end

  class << self
    def post(url, message, &block)
      self.new(url).post(message, &block)
    end
  end

  private

  def try_request(message)
    response = build_http_connection.start do |http|
      http.request(build_request(message))
    end

    yield response.code.to_i != 200, {message: response.body, code: response.code.to_i} if block_given?
  end

  def build_request(message)
    req = Net::HTTP::Post.new(@path)
    req.set_form(message)
    req
  end

  def build_http_connection
    http_connection = Net::HTTP.new(@host, @port)
    http_connection.open_timeout = 0.5
    http_connection.read_timeout = 0.5
    http_connection
  end
end