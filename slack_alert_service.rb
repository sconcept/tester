require 'cucumber'
require 'report_builder'

ReportBuilder.configure do |config|
  config.json_path = 'testartifacts/results'
  config.report_types = [:json]
  config.report_title = 'My Test Results'
  config.include_images = false
  config.additional_info = {browser: 'Chrome', environment: 'Stage 5'}
end

output = ReportBuilder.build_report
puts output
