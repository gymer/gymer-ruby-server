module Gymer
  class Client
    class << self
      attr_writer :config
    end

    def self.config
      @config ||= Configuration.new
    end

    def self.configure
      yield config
    end

    def self.reset
      @config = Configuration.new
    end

    attr_accessor :config

    def initialize(options = {})
      @config = self.class.config.dup

      options.each_pair do |key, value|
        @config.send("#{key}=", value)
      end
      # options = @@default_options.merge(options)

      # @scheme, @host, @port, @api_version, @app_id, @config.client_access_token, @config.server_access_token = options.values_at(
      #   :scheme, :host, :port, :api_version, :app_id, :client_access_token, :server_access_token
      # )
    end

    def url(path = nil)
      URI::Generic.build({
        :scheme => @config.scheme,
        :host => @config.host,
        :port => @config.port,
        :path => "/#{@config.api_version}/apps/#{@config.app_id}#{path}"
      }).to_s
    end

    def push(channel, event, data)
      response = post("/events", {event: event, channel: channel, data: data})
      JSON.parse(response.body)
    end

    def post(path, data = {})
      url = url(path)
      auth = {:username => @config.client_access_token, :password => @config.server_access_token}
      HTTParty.post(url, basic_auth: auth, body: data.to_json)
    end

    def get(path, params = {})
      url = url(path)
      auth = {:username => @config.client_access_token, :password => @config.server_access_token}
      HTTParty.get(url, basic_auth: auth)
    end

    def channel(name)
      response = get("/channels/#{name}")
      JSON.parse(response.body)
    end
  end
end
