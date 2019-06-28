require 'spec_helper'

RSpec.describe ManagingFeedback::ClientSecretsLoader do
  context "the secrets file exists" do
    it "loads the contents of the file" do
      secrets = described_class.load
      expect(secrets.client_id).to eq("client_id")
      expect(secrets.client_secret).to eq("client_secret")
    end
  end
  context "the secrets file doesn't exist" do
    it "raises an argument error" do
      expect { described_class.load("non_existent_file.json.erb") }.to raise_error(ArgumentError)
    end
  end
end
