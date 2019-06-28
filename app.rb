require_relative "lib/managing_feedback/feedback_gatherer"
require_relative "lib/managing_feedback/client_secrets_loader"
require_relative "lib/managing_feedback/google_authenticator"
require_relative "lib/managing_feedback/feedback_filter"
require_relative "lib/managing_feedback/brexit_slug_fetcher"
require_relative "lib/managing_feedback/sheets_auth"
require 'sinatra'
require 'dotenv'
require 'date'

set :public_folder, settings.root + '/assets'
enable :sessions

class SmartSurveyFeedback < Sinatra::Application
  get '/' do
    erb :home
  end

  get '/auth' do
    Dotenv.load("fixtures/variables.env")
    client_secrets = ManagingFeedback::ClientSecretsLoader.load
    authentication = ManagingFeedback::GoogleAuthenticator.new(client_secrets)
    auth_uri = authentication.auth_client.authorization_uri.to_s
    session['from_date'] = Time.parse("#{params['feedback-from-year']}-#{params['feedback-from-month']}-#{params['feedback-from-day']}").to_i
    session['to_date'] = Time.parse("#{params['feedback-until-year']}-#{params['feedback-until-month']}-#{params['feedback-until-day']}").to_i + 86400
    session['auth_client'] = authentication.auth_client
    redirect auth_uri
  end

  get '/results' do
    session['auth_client'].code = params['code']
    Dotenv.load("fixtures/variables.env")
    if ManagingFeedback::SheetsAuth.new(session['auth_client']).authorised
      slugs = ManagingFeedback::BrexitSlugFetcher.new(session['auth_client']).slugs
      feedback = ManagingFeedback::FeedbackGatherer.new(session['from_date'], session['to_date']).feedback
      @brexit_feedback = ManagingFeedback::FeedbackFilter.new(feedback, slugs).filtered_feedback
      erb :results
    else
      erb :unauthorised
    end
  end
end
