require 'spec_helper'

describe Gymer::Client do
  before do
    @client = Gymer::Client.new({
      :app_id => '1',
      :client_access_token => '1234567',
      :server_access_token => '12345678'
    })
  end

  describe 'default configuration' do
    it 'api scheme' do
      expect(@client.config.scheme).to eq('http')
    end

    it 'api host' do
      expect(@client.config.host).to eq('api.gymer.com')
    end
  end

  describe 'configure options' do
    it 'app_id, client_access_token, server_access_token' do
      expect(@client.config.app_id).to eq('1')
      expect(@client.config.client_access_token).to eq('1234567')
      expect(@client.config.server_access_token).to eq('12345678')
    end
  end

  describe '#configure' do
    before :each do
      Gymer::Client.configure do |config|
        config.host = 'localhost'
        config.port = 8001
        config.app_id = '1'
        config.client_access_token = '62b46ef8a1f8e574'
        config.server_access_token = '9ea9485d2a7e8069'
      end
    end

    after :each do
      Gymer::Client.reset
    end

    it 'set default options for clients' do
      @client = Gymer::Client.new

      expect(@client.config.host).to eq('localhost')
      expect(@client.config.port).to eq(8001)
      expect(@client.config.app_id).to eq('1')
    end

    it 'can be overrided on initialize or through setters' do
      @client = Gymer::Client.new(app_id: '10')

      expect(@client.config.app_id).to eq('10')
      @client.config.app_id = '25'
      expect(@client.config.app_id).to eq('25')
    end
  end

  describe '#url' do
    it 'build full URL for path' do
      expect(@client.url('/events')).to eq('http://api.gymer.com/v1/apps/1/events')
    end

    it 'with port if setted' do
      @client.config.port = 8080
      expect(@client.url('/events')).to eq('http://api.gymer.com:8080/v1/apps/1/events')
    end
  end

  describe '#push' do
    before :each do
      @path = %r{/v1/apps/1/events}
      stub_request(:post, @path).to_return(status: 200, body: {pushed_clients: 1}.to_json)
    end

    it 'send POST request to API' do
      request_url = "http://#{@client.config.client_access_token}:#{@client.config.server_access_token}@api.gymer.com/v1/apps/1/events"
      response = @client.push('test_channel', 'test_event', {title: 'Hi', subject: 'To my friend'})

      expect(WebMock).to have_requested(:post, request_url)
        .with(:body => {event: "test_event", channel: "test_channel", data: {title: 'Hi', subject: 'To my friend'}}.to_json)

      expect(response["pushed_clients"]).to eq(1)
    end
  end

  describe '#channel' do
    before :each do
      @path = %r{/v1/apps/1/channels/my-public-channel}
      stub_request(:get, @path).to_return(status: 200, body: {subscribers: 1, used: true}.to_json)
    end

    it 'send GET request to API' do
      request_url = "http://#{@client.config.client_access_token}:#{@client.config.server_access_token}@api.gymer.com/v1/apps/1/channels/my-public-channel"
      response = @client.channel('my-public-channel')

      expect(WebMock).to have_requested(:get, request_url)
      expect(response["used"]).to eq(true)
      expect(response["subscribers"]).to eq(1)
    end
  end
end
