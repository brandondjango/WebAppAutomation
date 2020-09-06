When(/^I search for "([^"]*)"$/) do |arg|
  page = visit_page(GoogleHomePage)
  page.search_for_term(page.search_bar_element, arg)
  sleep(5)
end


And(/^I sleep "([^"]*)" seconds$/) do |number|
  sleep(3)
  puts ENV[:TEST_ENV_NUMBER.to_s]
end