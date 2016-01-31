module Gymer
  class Client
    attr_accessor :scheme, :host, :port, :api_version, :app_id, :client_access_token, :server_access_token

    def initialize(options = {})
      options = {
        :scheme => 'http',
        :host => 'api.gymer.com',
        :api_version => 'v1',
      }.merge(options)

      puts options

      @scheme, @host, @port, @api_version, @app_id, @client_access_token, @server_access_token = options.values_at(
        :scheme, :host, :port, :api_version, :app_id, :client_access_token, :server_access_token
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
        :path => "/#{@api_version}/apps/#{@app_id}#{path}"
      }).to_s
    end

    def push(channel, event, data)
      response = post("/events", {event: event, channel: channel, data: data})
      JSON.parse(response.body)
    end

    def post(path, data = {})
      url = url(path)
      auth = {:username => @client_access_token, :password => @server_access_token}
      HTTParty.post(url, basic_auth: auth, body: data.to_json)
    end

    def get(path, params = {})
      url = url(path)
      auth = {:username => @client_access_token, :password => @server_access_token}
      HTTParty.get(url, basic_auth: auth)
    end

    def channel(name)
      response = get("/channels/#{name}")
      JSON.parse(response.body)
    end
  end
end
