require 'watir'
require 'page-object'
require 'page-object/page_factory'
require 'dotenv'
require 'pry'
Dotenv.load('.env') # loads environment variables from .env file

  World(PageObject::PageFactory)
  @default_driver = 'chrome'



  isGrid = ENV['RUN_LOCAL'].to_s == 'true' ? true : false
  gridUrl = ENV['SELENIUM_GRID_URL']
  driver = ENV['SELENIUM_BROWSER'].to_s.downcase



  def setup_grid(driver)
    if driver == 'chrome'
      capabilities = Selenium::WebDriver::Remote::Capabilities.new
      @browser = Watir::Browser.new(
      :remote,
      :url => gridUrl,
      :desired_capabilities => capabilities)
    end
  end

  def setup_local(driver)
    if driver == 'chrome'
      @browser = Watir::Browser.new :chrome
    elsif driver == 'firefox'
      @browser = Watir::Browser.new :firefox, marionette: true
    end
  end

Before do |scenario|
  if isGrid
    setup_local(driver)
  end
  if !isGrid
     setup_grid(driver)
  end
  @browser.driver.manage.window.maximize
  end

After do |scenario|
  begin
    if scenario.failed?
      Dir::mkdir('testartifacts/screenshots') if not File.directory?('testartifacts/screenshots')
      screenshot = "./testartifacts/screenshots/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}.png"
      @browser.driver.save_screenshot(screenshot)
      embed screenshot, 'image/png'
    end
  ensure
    @browser.close
  end
end
