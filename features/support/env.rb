require 'simplecov' if ENV['COVERAGE']

require 'aruba/cucumber'
require 'chef_gen/flavors/cucumber'

Before do
  @aruba_timeout_seconds = 10
end
