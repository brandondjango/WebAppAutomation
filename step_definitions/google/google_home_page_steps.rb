When(/^I search for "([^"]*)"$/) do |arg|
  page = visit_page(GoogleHomePage)
  page.search_for_term(page.search_bar_element, arg)
end


And(/^I sleep "([^"]*)" seconds$/) do |number|
  sleep(number.to_i)
end