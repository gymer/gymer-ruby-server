$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'gymer'
require 'webmock/rspec'

RSpec.configure do |config|
  config.before(:each) do
    WebMock.reset!
    WebMock.disable_net_connect!
  end
end
