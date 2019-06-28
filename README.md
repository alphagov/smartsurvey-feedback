#  Managing Feedback

This is a basic Sinatra app that gathers all of the Brexit related feedback out of Smart Surveys and puts them into an HTML table. That table can then easily be copied over to google sheets or excel.

## Running the Application Locally

There are a few environment variables that this application needs to run properly. They are stored in the fixtures folder. Copy the `fixtures/variables-template.env` to `fixtures/variables.env`. All of the fields will need filling in. The smart survey secrets are available after logging into smart survey under `Account -> My Account -> Advanced -> API Keys -> Managing Feedback`. The rest of the secrets are held within the govuk-secrets repo.

This application relies on Google auth and the sheets api. Auth only allows an absolute redirect URI. As such you will need to make a small change to the `lib/google_authenticator.rb` file and then run `rackup -p 4567` to run this application locally.

## Deploying the Application

There is a live version of this application [here](https://smartsurveyfeedback.cloudapps.digital/). It is currently running on the [Paas](https://www.cloud.service.gov.uk/). In order to deploy this application you will need access to the sandbox within the govuk_development organisation and follow normal procedure for PaaS deployment. The redirect uri in `lib/google_authenticator.rb` will need changing to reflect the live environment before deployment.

## Further Information

Effort has been made to restrict access to this application to those that need it. There is no simple way of allowing specific users access to authenticate using google. The work around for this has been to create a new spreadsheet that is only viewable by members of the managing feedback team. Access to this spreadsheet will have to be granted before you can see feedback. This method also allows the application to be updated without developer intervention.

Users are asked not to submit identifying information when giving the feedback that this application gathers. Occasionally they do submit things they should not, please consider this before sharing results from this application.

## Licence

[MIT License](LICENSE)
