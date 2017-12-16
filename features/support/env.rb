require 'watir'
require 'page-object'
require 'page-object/page_factory'
require 'dotenv'
require 'pry'
require 'i18n'
require 'fileutils'
require 'report_builder'
Dotenv.load('.env') # loads environment variables from .env file

  World(PageObject::PageFactory)
  @default_driver = 'chrome'
  run_dir = FileUtils.mkdir_p("testartifacts/Automation_build_#{Time.new.localtime.strftime("%F_%H_%M_%S")}")
  value = run_dir.to_s
  $VALUE = value[2..-3]


  isGrid = ENV['RUN_LOCAL'].to_s == 'true' ? true : false
  gridUrl = ENV['SELENIUM_GRID_URL']
  driver = ENV['SELENIUM_BROWSER'].to_s.downcase
  $APPLICATION_NAME = ENV['APPLICATION_NAME']

  #Setting up test run directories in artifacts in order to bundle everything together into a single 'run'
  def setup_run_artifacts
    FileUtils.mkdir_p("./#{Dir.glob("#{$VALUE}/").max_by {|f| File.mtime(f)}}test_logs")
    FileUtils.mkdir_p("./#{Dir.glob("#{$VALUE}/").max_by {|f| File.mtime(f)}}test_report")
    FileUtils.mkdir_p("./#{Dir.glob("#{$VALUE}/").max_by {|f| File.mtime(f)}}test_results")
    FileUtils.mkdir_p("./#{Dir.glob("#{$VALUE}/").max_by {|f| File.mtime(f)}}test_screenshots") unless File.exists?("./#{Dir.glob("#{$VALUE}/").max_by {|f| File.mtime(f)}}test_screenshots")
  end

 #Language setup for localisation, utilising i18n, yml files can be found at => /features/configuration_resources, update as you go if your app requires multilingual!
 #Configuration comes from a language in the .env
   def setup_language_resources
     I18n.load_path = ['features/resources/localisation/english.yml']

     case ENV['Language']
     when 'english'
       I18n.locale = :en
     when 'spanish'
       I18n.locale = :es
     when 'italian'
       I18n.locale = :it
     else
       abort("Incorrect language set, cannot continue the test run: supported are 'english', 'italian' or 'spanish'")
     end
   end

     setup_run_artifacts
     setup_language_resources


  #Setting up our grid driver information
  def setup_grid(driver)
    if driver == 'chrome'
      capabilities = Selenium::WebDriver::Remote::Capabilities.new
      @browser = Watir::Browser.new(
      :remote,
      :url => gridUrl,
      :desired_capabilities => capabilities)
    end
  end

  #Setting up our browser information
  def setup_local(driver)
    if driver == 'chrome'
      @browser = Watir::Browser.new :chrome
    elsif driver == 'firefox'
      @browser = Watir::Browser.new :firefox, marionette: true
    end
  end

  #Setting up our logger information
  def setup_logger(log_name)
    date = Time.new.localtime.strftime("%F %H.%M.%S%L")
    logger = Logger.new("#{$VALUE}/test_logs/#{log_name}_#{date}.log")
    logger.formatter = proc do |severity, datetime, progname, msg|
    date_format = datetime.strftime("%Y-%m-%d %H:%M:%S%L")
    if severity == "INFO" or severity == "WARN"
        "[#{date_format}] #{severity}  (#{ENV['PRODUCT_NAME']}): #{msg}\n"
    else
        "[#{date_format}] #{severity} (#{ENV['PRODUCT_NAME']}): #{msg}\n"
    end
  end
    logger
  end

  #configure report builder
  ReportBuilder.configure do |config|
    config.json_path = "#{$VALUE}/test_results}"
    config.report_path = 'Automation Run Report'
    config.report_types = [:json, :html]
    config.report_title = "#{ENV['PRODUCT_NAME']} Automation Report"
    config.include_images = true
  end

  #Cucumber before scenario hook
  Before do |scenario|
    @locale = I18n
    @log = setup_logger("#{scenario.name}")
    @log.debug("Starting scenario: #{scenario.name}")
    if isGrid
      setup_local(driver)
    end
    if !isGrid
      setup_grid(driver)
    end
    @browser.driver.manage.window.maximize
  end

  #Cucumber after scenario hook
  After do |scenario|
    begin
      if scenario.failed?
        @log.error("#{scenario.name} FAILED! => Logging screenshot in #{$VALUE}/test_screenshots")
        screenshot = "#{$VALUE}/test_screenshots/FAILED_#{scenario.name.gsub(' ','_').gsub(/[^0-9A-Za-z_]/, '')}_#{Time.new.localtime.strftime("%F %H.%M.%S%L")}.png"
        @browser.driver.save_screenshot(screenshot)
        embed screenshot, 'image/png'
      end
    ensure
      @browser.close
    end
  end

  #after all hook workaround
  at_exit do
    FileUtils.mv Dir['testartifacts/*.json'], "#{$VALUE}/test_results", force: true
    options = {
       json_path:   "#{$VALUE}/test_results/",
       report_path:  "#{$VALUE}/test_report/auto_run_report",
       report_types: ['json', 'html'],
       report_title: "#{$APPLICATION_NAME} - Automation Report, #{Time.now.strftime("%F %H %M ")}",
       include_images: true,
     }

    ReportBuilder.build_report options
  end
