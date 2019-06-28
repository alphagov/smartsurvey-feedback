class ManagingFeedback
  class FeedbackFilter
    attr_accessor :filtered_feedback
    def initialize(raw_feedback, slugs)
      @page_id_hash = YAML.load_file("fixtures/page_id_hash.yaml")
      @tracking_link_id_hash = YAML.load_file("fixtures/tracking_link_id_hash.yaml")
      @slugs = slugs
      @raw_feedback = raw_feedback
      @filtered_feedback = filter_feedback
    end

    def filter_feedback
      return_object = []
      @raw_feedback.each do |feedback_item|
        response_item = response_template
        if feedback_item['variables'] != nil
          feedback_item['variables'].each do |variable|
            if variable['label'] == 'Page Path' && variable['value'] != nil && is_brexity?(variable['value'])
              response_item["Entry Point"] = @tracking_link_id_hash[feedback_item["tracking_link_id"]]
              response_item['Date and time'] = feedback_item['date_ended'].tr('-T', '/ ').delete('Z')
              response_item['Page Path'] = variable['value']
              response_item['UserNo'] = feedback_item['id']
              feedback_item['pages'].each do |page|
                page['questions'].each do |question|
                  question_asked = @page_id_hash[question['id']]
                  question['answers'].each do |answer|
                    response_item[question_asked] = find_question_asked(answer)
                  end
                end
              end
            end
          end
        end
        return_object << response_item if (response_item.values - [""]).empty? == false
      end
      return_object
    end

  private

    def find_question_asked(answer)
      if answer.has_key?('value')
        answer['value']
      elsif answer.has_key?('column_id')
        @page_id_hash[answer['column_id']]
      else
        @page_id_hash[answer['choice_id']]
      end
    end

    def response_template
      {
        "Date and time" => "",
        "Page Path" => "",
        "UserNo" => "",
        "Entry Point" => "",
        "Q1. Are you using GOV.UK for professional or personal reasons?" => "",
        "Q2. What kind of work do you do?" => "",
        "Q3. Describe why you came to GOV.UK today" => "",
        "Q4. Have you found what you were looking for?" => "",
        "Q5. Overall, how did you feel about your visit to GOV.UK today?" => "",
        "Q6. Have you been anywhere else for help with this already?" => "",
        "Q7. Where did you go for help?" => "",
        "Q8. If you wish to comment further, please do so here" => "",
      }
    end

    def is_brexity?(url)
      @slugs.filter { |slug| url.start_with?(slug) }.empty? ? false : true
    end
  end
end
