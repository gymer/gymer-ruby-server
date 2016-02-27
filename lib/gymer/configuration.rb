module Gymer
  class Configuration
    attr_accessor :scheme, :host, :port, :api_version, :app_id, :client_access_token, :server_access_token

    def initialize
      @host        = 'api.gymer.com'
      @scheme      = 'http'
      @api_version = 'v1'
    end
  end
end