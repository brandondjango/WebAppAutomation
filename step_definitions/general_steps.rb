When(/^I go to the url "([^"]*)"$/) do |url|
  page = BasePage.new @browser
  page.go_to_url(url)
end

Then(/^I should be on a page with the url "([^"]*)"$/) do |url|
  expect(@browser.url.include?(url)).to (be true), "Expected to be on page #{url} but was on #{@browser.url}"
end

Then(/^I should be on a new tab with the url "([^"]*)"$/) do |url|
  #todo fix wait condition
  sleep 2
  @browser.windows.last.use
  expect(@browser.url.include?(url)).to (be true), "Expected to be on page #{url} but was on #{@browser.url}"
end

And(/^I open the current page in a new tab$/) do
  current_url = @browser.url

  if ENV["BROWSER"].nil? || ENV["BROWSER"].downcase.include?("chrome")
    @browser.execute_script("window.open(\"#{current_url}\")")
    @browser.windows.last.use
  else ENV["BROWSER"].downcase.include?("firefox")
  @browser = Watir::Browser.new(:firefox, acceptInsecureCerts: true) unless ENV["NO_BROWSER"]
  end

  @browser.goto current_url
end