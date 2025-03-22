require 'capybara/rspec'

Capybara.register_driver :selenium_chrome_headless do |app|
  browser_options = Selenium::WebDriver::Chrome::Options.new
  browser_options.add_argument('--headless=new')
  browser_options.add_argument('--no-sandbox')
  browser_options.add_argument('--disable-dev-shm-usage')
  browser_options.add_argument('--disable-gpu')
  browser_options.add_argument('--window-size=1920,1080')
  browser_options.add_argument('--enable-features=NetworkService,NetworkServiceInProcess')

  if ENV['CHROME_BIN'].present?
    browser_options.binary = ENV['CHROME_BIN']
  end

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: browser_options
  )
end

Capybara.default_driver = :selenium_chrome_headless
Capybara.javascript_driver = :selenium_chrome_headless

# Configure Capybara
Capybara.default_max_wait_time = 5
Capybara.server = :puma, { Silent: true }
Capybara.default_normalize_ws = true
