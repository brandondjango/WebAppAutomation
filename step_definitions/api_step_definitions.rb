Given(/^the following API request:$/) do |json|
  # Running the text through the parser in order to clean up whitespace
  @json_request = JSON.parse(json).to_json
end

When(/^the "(.*)" request is sent to "(.*)"$/) do | request_type, endpoint_url|
  case request_type.downcase
  when "get"
    result = RestClient.get(endpoint_url, {accept: :json})
  when "post"
    result = RestClient.post(endpoint_url, @json_request)
  when "delete"
    result = RestClient.delete(endpoint_url, @json_request)
  else
    raise RuntimeError, "Request type: #{request_type} is invalid"
  end
  @response = result
  print "\n\n\n\nCALL: \n\n\n" + @response
end
##iiif = image, iiif-info = manifest
Then(/^the following response is received:$/) do |json|
  # Running both halves through the parser in order to remove whitespace inconsistencies
  compare_json(JSON.parse(json).sort, JSON.parse(@response).sort)
end

And(/^the status code is "([^"]*)"$/) do |status_code|
  expect(@response.code).to eq(status_code.to_i)
end