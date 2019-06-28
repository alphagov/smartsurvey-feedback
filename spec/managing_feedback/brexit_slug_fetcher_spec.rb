require 'spec_helper'
require 'google/apis/sheets_v4'

RSpec.describe ManagingFeedback::BrexitSlugFetcher do
  class FakeSheetWithoutAuth < Google::Apis::SheetsV4::SheetsService
    def get_spreadsheet_values(_id, _range)
      raise Google::Apis::AuthorizationError.new("no permission")
    end
  end

  class FakeSheetWithAuth < Google::Apis::SheetsV4::SheetsService
    def get_spreadsheet_values(_id, _range)
      FakeSpreadsheetObject.new
    end
  end

  class FakeSpreadsheetObject
    def values
      ["/", "/appropriate", "/slugs"]
    end
  end

  before do
    ENV["SPREADSHEET_1"] = "spreadsheet_1"
    ENV["SPREADSHEET_2"] = "spreadsheet_2"
  end

  after do
    ENV.delete("SPREADSHEET_1")
    ENV.delete("SPREADSHEET_2")
  end

  context "access without authorisation" do
    it "raises a google auth error" do
      allow(Google::Apis::SheetsV4::SheetsService).to receive(:new).and_return(FakeSheetWithoutAuth.new)
      expect { described_class.new("fake_auth_client") }.to raise_error(Google::Apis::AuthorizationError)
    end
  end

  context "access with authorisation" do
    it "returns the appropriate slugs" do
      allow(Google::Apis::SheetsV4::SheetsService).to receive(:new).and_return(FakeSheetWithAuth.new)
      slugs = described_class.new("fake_auth_client").slugs
      expect(slugs).to eq(["/", "/appropriate", "/slugs"])
    end
  end
end
