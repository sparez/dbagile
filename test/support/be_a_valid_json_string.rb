RSpec::Matchers.define :be_a_valid_json_string do
  match do |actual|
    begin
      JSON::parse(actual)
      true
    rescue JSON::JSONError
      false
    end
  end
  failure_message_for_should do |actual|
    "expected that #{actual.inspect} would be a valid JSON string"
  end
  failure_message_for_should_not do |actual|
    "expected that #{actual.inspect} would not be a valid JSON string"
  end
  description do
    "a valid JSON string"
  end
end
