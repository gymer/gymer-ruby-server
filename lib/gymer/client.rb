module Gymer
  class Client
    attr_accessor :scheme, :host, :port, :app_id, :client_access_token, :server_access_token

    def initialize(options = {})
      options = {
        :scheme => 'http',
        :host => 'api.gymer.com',
      }.merge(options)
      @scheme, @host, @port, @app_id, @client_access_token, @server_access_token = options.values_at(
        :scheme, :host, :port, :app_id, :client_access_token, :server_access_token
      )

      # Default timeouts
      @connect_timeout = 5
      @send_timeout = 5
      @receive_timeout = 5
      @keep_alive_timeout = 30
    end

    def url(path = nil)
      URI::Generic.build({
        :scheme => @scheme,
        :host => @host,
        :port => @port,
        :path => "/apps/#{@app_id}#{path}"
      }).to_s
    end

    def push(channel, event, data)
      url = url("/events")
      auth = {:username => @client_access_token, :password => @server_access_token}
      response = HTTParty.post(url, basic_auth: auth, body: {event: event, channel: channel, data: data})
      JSON.parse(response.body)
    end

    def get(path)
      url = "https://api.groovehq.com/v1/#{path}"
      response = HTTParty.get(url, headers: { 'Authorization' => "Bearer #{@access_token}" })
      JSON.parse(response.body)
    end
  end
end
