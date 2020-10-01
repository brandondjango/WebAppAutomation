When(/^I search for "([^"]*)"$/) do |search_term|
  page = GoogleHomePage.new @browser
  page.go_to_page_url
  page.search_for_term(search_term)
end


And(/^I sleep "([^"]*)" seconds$/) do |number|
  sleep(number.to_i)
end