# Notify any waiting tests that they are free to run.

After do |scenario|
  @scenario_pass_status = scenario.passed?
end

After do
  @browser.close
end

After do
    @browser.screenshot.save "screenshots/#{@scenario_name}.png" rescue print "There was an error with printing the screenshot"
end