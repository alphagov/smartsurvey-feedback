require 'google/apis/sheets_v4'

class ManagingFeedback
  class BrexitSlugFetcher
    APPLICATION_NAME = 'Managing Smart Survey Feedback'.freeze
    attr_accessor :slugs
    def initialize(auth_client)
      @spreadsheet_hash = YAML.load_file("fixtures/spreadsheet_codes.yaml")
      @auth_client = auth_client
      @slugs = (get_taxon_slugs + get_google_sheets_slugs).flatten.uniq
      # @slugs = ["/budgeting-help-benefits"]
    end

  private

    def get_taxon_slugs
      uri = URI("https://www.gov.uk/api/search.json?filter_taxons=d7bdaee2-8ea5-460e-b00d-6e9382eb6b61&count=50&fields=description&fields=link&fields=title")
      response = Net::HTTP.get_response(uri)
      JSON.parse(response.body)["results"].map { |page| page["link"] }
    end

    def get_home_office_slugs
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = @auth_client
      spreadsheet_id = "1Pzjeae33PQKzekCJfx95VYlNNPH6ePhsQSMFEIrsY5g"
      range = 'Brexit Docs!H4:A'
      response = service.get_spreadsheet_values(spreadsheet_id, range)
      hash = {}
      response.values.each { |row| hash[row[0]] = row[-1] }.select { |_x, y| ["Home Office", "UK Visas and Immigration"].include?(y) }
      hash.keys - [""]
    end

    def get_google_sheets_slugs
      service = Google::Apis::SheetsV4::SheetsService.new
      service.client_options.application_name = APPLICATION_NAME
      service.authorization = @auth_client
      @spreadsheet_hash.map do |id, range|
        service.get_spreadsheet_values(id, range).values
      end
    end
  end
end
