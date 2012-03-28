require 'rubygems'
require 'marmalade'

RSpec.configure do |config|
  config.mock_framework = :mocha
end

def fixture_file(file_name)
  File.join(File.expand_path("../fixtures", __FILE__), file_name)
end

