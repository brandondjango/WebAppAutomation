require 'require_all'
require_rel 'common_env.rb'

#Environment Variables



def start
  @browser = Watir::Browser.new(:chrome, switches: ['--ignore-certificate-errors'])
  #page = GoogleHomePage.new @browser
  #@browser.goto page.url_for_page
end

def start_mobile_rui
  driver = Webdriver::UserAgent.driver(browser: :chrome, agent: :iphone, orientation: :portrait)
  @browser = Watir::Browser.new driver
  page = GoogleHomePage.new @browser
  @browser.goto page.url_for_page
end
