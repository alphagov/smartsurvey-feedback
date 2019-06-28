require 'spec_helper'

RSpec.describe ManagingFeedback::FeedbackGatherer do
  before do
    ENV["SURVEY_NUMBER"] = "number"
    ENV["SMART_SURVEY_API_TOKEN"] = "token"
    ENV["SMART_SURVEY_API_SECRET_TOKEN"] = "secret_token"
  end

  after do
    ENV.delete("SURVEY_NUMBER")
    ENV.delete("SMART_SURVEY_API_TOKEN")
    ENV.delete("SMART_SURVEY_API_SECRET_TOKEN")
  end

  context "there is feedback" do
    it "gathers it all" do
      stub_request(:get, "https://api.smartsurvey.io/v1/surveys/number/responses?api_token=token&api_token_secret=secret_token&include_labels=true&page=1&page_size=100&since=569571436800&until=569571523200").
           to_return(status: 200, body: '["actual feedback"]', headers: {})

      stub_request(:get, "https://api.smartsurvey.io/v1/surveys/number/responses?api_token=token&api_token_secret=secret_token&include_labels=true&page=2&page_size=100&since=569571436800&until=569571523200").
           to_return(status: 200, body: '["more feedback"]', headers: {})

      stub_request(:get, "https://api.smartsurvey.io/v1/surveys/number/responses?api_token=token&api_token_secret=secret_token&include_labels=true&page=3&page_size=100&since=569571436800&until=569571523200").
           to_return(status: 200, body: '[]', headers: {})

      feedback = described_class.new(569571436800, 569571523200)
      expect(feedback.feedback).to eq(["actual feedback", "more feedback"])
    end
  end

  context "there is no feedback" do
    it "tries to gather and returns an empty response" do
      stub_request(:get, "https://api.smartsurvey.io/v1/surveys/number/responses?api_token=token&api_token_secret=secret_token&include_labels=true&page=1&page_size=100&since=569571436800&until=569571523200").
           to_return(status: 200, body: '[]', headers: {})
      feedback = described_class.new(569571436800, 569571523200)
      expect(feedback.feedback).to eq([])
    end
  end
end
