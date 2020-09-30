#3rd party gems
require 'page-object'
require 'watir'
require 'selenium-webdriver'
require 'rest-client'
require 'webdrivers'
require 'webdriver-user-agent'
require 'java'
#require 'rukuli'


include PageObject::PageFactory

#Internal directories
require_rel('../browser_page_models')
#require_rel('../helpers')

#def visit_page(page)
#  @browser.goto page.url_for_page
#end


