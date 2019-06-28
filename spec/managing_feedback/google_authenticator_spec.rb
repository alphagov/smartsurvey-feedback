require 'spec_helper'

RSpec.describe ManagingFeedback::GoogleAuthenticator do
  context "the environment variables are not set" do
    it "raises an argument error" do
      secrets = ManagingFeedback::ClientSecretsLoader.load
      expect { described_class.new(secrets) }.to raise_error(ArgumentError)
    end
  end
  context "the environment variables not set" do
    before do
      ENV["GOOGLE_CLIENT_ID"] = "new_client_id"
      ENV["GOOGLE_CLIENT_SECRET"] = "new_client_secret"
    end
    after do
      ENV.delete("GOOGLE_CLIENT_ID")
      ENV.delete("GOOGLE_CLIENT_SECRET")
    end
    it "creates the object properly" do
      secrets = ManagingFeedback::ClientSecretsLoader.load
      expect(described_class.new(secrets).auth_client.client_id).to eq("new_client_id")
    end
  end
end
