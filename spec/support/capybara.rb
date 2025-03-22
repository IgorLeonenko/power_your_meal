require 'capybara/rspec'

Capybara.register_driver :selenium_chrome_headless do |app|
  browser_options = Selenium::WebDriver::Chrome::Options.new
  browser_options.add_argument('--headless=new')
  browser_options.add_argument('--no-sandbox')
  browser_options.add_argument('--disable-dev-shm-usage')
  browser_options.add_argument('--disable-gpu')

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
