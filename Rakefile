require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :lint do
  system("bundle exec govuk-lint-ruby fixtures lib spec app.rb")
end

task default: %i[spec lint]
