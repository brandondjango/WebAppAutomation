require_relative '../support/cucumber_env'

def windows?
  (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
end

Before do |scenario|

  # Scenario name
  @scenario_name = scenario.name

  # Tags (as an array)
  @scenario_tags = scenario.source_tag_names

  print @scenario_name + "\n"
end


Before do
  #caps = Selenium::WebDriver::Remote::Capabilities.new
  #caps[:browserName] = "chrome"

  #@browser = Watir::Browser.new(:remote, :url =>'http://localhost:4444/wd/hub', :desired_capabilities => caps)


  if ENV["BROWSER"].nil? || ENV["BROWSER"].downcase.include?("chrome")
    @browser = Watir::Browser.new(:chrome, switches: ['--ignore-certificate-errors'] ) unless ENV["NO_BROWSER"]
  elsif ENV["BROWSER"].downcase.include?("firefox")
    capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(accept_insecure_certs: true, assume_untrusted_issuer: true)
    @browser = Watir::Browser.new(:firefox, desired_capabilites: capabilities) unless ENV["NO_BROWSER"]
  elsif ENV["BROWSER"].downcase.include?("mobile")
    driver = Webdriver::UserAgent.driver(browser: :chrome, agent: :iphone, orientation: :portrait)
    @browser = Watir::Browser.new driver
  end
end
