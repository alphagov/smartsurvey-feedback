require 'google/apis/sheets_v4'

class ManagingFeedback
  class SheetsAuth
    APPLICATION_NAME = 'Managing Smart Survey Feedback'.freeze
    attr_reader :authorised
    def initialize(auth_client)
      @auth_client = auth_client
      @authorised = authenticate
    end

    def authenticate
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = @auth_client
      spreadsheet_id = ENV.fetch("AUTH_SPREADHEET")
      range = 'Sheet1!A1:A'
      begin
        service.get_spreadsheet_values(spreadsheet_id, range)
      rescue Google::Apis::ClientError
        return false
      else
        return true
      end
    end
  end
end
