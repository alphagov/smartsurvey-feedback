require 'net/https'
require 'open-uri'
require 'json'

class ManagingFeedback
  class FeedbackGatherer
    attr_reader :feedback
    def initialize(date_from, date_to)
      @date_from = date_from
      @date_to = date_to
      @feedback = gather_all_feedback
    end

    def gather_all_feedback
      return_object = []
      response_body = ""
      page_number = 0

      until response_body == "[]" do
        page_number += 1
        uri = URI("https://api.smartsurvey.io/v1/surveys/#{ENV.fetch('SURVEY_NUMBER')}/responses?api_token=#{ENV.fetch('SMART_SURVEY_API_TOKEN')}&api_token_secret=#{ENV.fetch('SMART_SURVEY_API_SECRET_TOKEN')}&page_size=100&since=#{@date_from}&until=#{@date_to}&page=#{page_number}&include_labels=true")
        response = Net::HTTP.get_response(uri)
        return_object << JSON.parse(response.body)
        response_body = response.body
      end
      return_object.flatten
    end
  end
end
