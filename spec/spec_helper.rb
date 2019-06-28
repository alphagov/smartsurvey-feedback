require_relative '../lib/managing_feedback/client_secrets_loader'
require_relative '../lib/managing_feedback/feedback_gatherer'
require_relative '../lib/managing_feedback/brexit_slug_fetcher'
require_relative '../lib/managing_feedback/feedback_filter'
require_relative '../lib/managing_feedback/client_secrets_loader'
require_relative '../lib/managing_feedback/google_authenticator'

require 'webmock/rspec'
require 'pry'

WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, "https://www.gov.uk/api/search.json?filter_taxons=d7bdaee2-8ea5-460e-b00d-6e9382eb6b61&count=50&fields=description&fields=link&fields=title").
      with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' }).
      to_return(status: 200, body: '{"results": [{"link": "/"}]}', headers: {})
  end
end
