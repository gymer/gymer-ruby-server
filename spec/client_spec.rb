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
      expect(@client.scheme).to eq('http')
    end

    it 'api host' do
      expect(@client.host).to eq('api.gymer.com')
    end
  end

  describe 'configure options' do
    it 'app_id, client_access_token, server_access_token' do
      expect(@client.app_id).to eq('1')
      expect(@client.client_access_token).to eq('1234567')
      expect(@client.server_access_token).to eq('12345678')
    end
  end

  describe '#url' do
    it 'build full URL for path' do
      expect(@client.url('/events')).to eq('http://api.gymer.com/apps/1/events')
    end

    it 'with port if setted' do
      @client.port = 8080
      expect(@client.url('/events')).to eq('http://api.gymer.com:8080/apps/1/events')
    end
  end

  # describe '#push' do
  #   it 'send POST request to API' do
  #     @client.push('test_channel', 'test_event', {title: 'Hi', subject: 'To my friend'})
  #   end
  # end
end
