require 'spec_helper'

RSpec.describe ManagingFeedback::FeedbackFilter do
  before do
    @raw_feedback = [{
      "id" => 100000000,
      "tracking_link_id" => 459710,
      "status" => "completed",
      "date_ended" => "2019-01-01T12:24:18Z",
      "variables" => [
        {
          "label" => "Page Path",
          "value" => "/"
        },
      ],
      "pages" => [{
        "questions" => [{
          "id" => 4440289,
          "answers" => [{
            "column_id" => 37077903
          }]
        }]
      }, {
        "questions" => [{
          "id" => 4440929,
          "answers" => [{
            "choice_id" => 37080292
          }]
        }]
      }, {
        "questions" => [{
          "id" => 4440933,
          "answers" => [{
            "value" => "A Comment"
          }]
        }]
      }]
    }]
  end
  context "everything's fine and there's brexity feedback" do
    it "processess the raw feedback" do
      filter = described_class.new(@raw_feedback, ["/"])

      expect(filter.filtered_feedback).to eq([{
        "Date and time" => "2019/01/01 12:24:18",
        "Entry Point" => "Footer Email",
        "Page Path" => "/",
        "Q1. Are you using GOV.UK for professional or personal reasons?" => "",
        "Q2. What kind of work do you do?" => "",
        "Q3. Describe why you came to GOV.UK today" => "",
        "Q4. Have you found what you were looking for?" => "",
        "Q5. Overall, how did you feel about your visit to GOV.UK today?" => "Satisfied",
        "Q6. Have you been anywhere else for help with this already?" => false,
        "Q7. Where did you go for help?" => "",
        "Q8. If you wish to comment further, please do so here" => "A Comment",
        "UserNo" => 100000000
      }])
    end
  end

  context "no feedback is brexity" do
    it "filters everything out" do
      filter = described_class.new(@raw_feedback, ["/fake/endpoint"])
      expect(filter.filtered_feedback).to eq([])
    end
  end
end
