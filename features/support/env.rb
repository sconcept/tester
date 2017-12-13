require 'watir'
require 'page-object'
require 'page-object/page_factory'
require 'dotenv'
require 'pry'
Dotenv.load('.env') # loads environment variables from .env file

World(PageObject::PageFactory)

@default_driver = 'chrome'
@browser = nil


isGrid = ENV['RUN_LOCAL'].to_s == 'true' ? true : false
gridUrl = ENV['SELENIUM_GRID_URL']
driver = ENV['DRIVER']

Before do |scenario|
  puts "Before Scenario: #{scenario.name}"
  if !isGrid
    if driver == 'chrome'
      @browser = Watir::Browser.new :chrome, detach: true
    elsif driver == 'firefox'
      @browser = Watir::Browser.new :firefox, marionette: true
    end
  elsif isGrid
    if driver == 'chrome'
      capabilities = Selenium::WebDriver::Remote::Capabilities.new
      capabilities.browser_name = "Grid - Chrome"
      @browser = Watir::Browser.new(
      :remote,
      :url => gridUrl,
      :desired_capabilities => capabilities)
    end
  end

end

After do |scenario|
  puts "After Scenario: #{scenario.name}"
  begin
    if scenario.failed?
      Dir::mkdir('screenshots') if not File.directory?('screenshots')
      screenshot = "./screenshots/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
      @browser.driver.save_screenshot(screenshot)
      embed screenshot, 'image/png'
    end
  ensure
    @browser.close
  end
end
