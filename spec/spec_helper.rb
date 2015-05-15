require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'

include RspecPuppetFacts

def fixture_data(name)
  path = File.join(File.dirname(__FILE__), 'fixtures/data', name)
  file = File.read(path)
  YAML.load(file)
end
