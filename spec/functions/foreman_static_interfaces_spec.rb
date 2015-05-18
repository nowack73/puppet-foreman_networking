require 'spec_helper'

describe 'the foreman_static_interfaces function' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('foreman_static_interfaces')).to eq('function_foreman_static_interfaces')
  end

  it 'should raise a ParseError if first argument is not a string' do
    expect { scope.function_foreman_static_interfaces([{}]).to raise_error(Puppet::ParseError) }
  end

  context 'when foreman_interfaces is not defined' do
    let(:facts) {{}}
    
    it 'should return an empty hash' do
      expect(scope.function_foreman_static_interfaces([])).to eq({})
    end
  end

  context 'when foreman_interfaces contains interface data' do
    let(:foreman_interfaces) { fixture_data('single_interface.yaml')['foreman_interfaces'] }
    before(:each) do
      scope.stubs(:lookupvar).with('foreman_interfaces').returns(foreman_interfaces)
    end
  
    it 'should return hash' do
      expect(scope.function_foreman_static_interfaces([])).to be_a(Hash)
    end

    it 'should set interface title' do
      expected_title = foreman_interfaces.first['identifier']
      expect(scope.function_foreman_static_interfaces([]).keys.first).to eq(expected_title)
    end
  end

  context 'when foreman_interfaces multiple interfaces data' do
    let(:foreman_interfaces) { fixture_data('two_interfaces_different_subnets.yaml')['foreman_interfaces'] }
    before(:each) do
      scope.stubs(:lookupvar).with('foreman_interfaces').returns(foreman_interfaces)
    end
  
    it 'should return hash' do
      expect(scope.function_foreman_static_interfaces([])).to be_a(Hash)
    end

    it 'should set interface titles' do
      expected_titles = foreman_interfaces.map { |h| h['identifier'] }.sort
      expect(scope.function_foreman_static_interfaces([]).keys.sort).to eq(expected_titles)
    end

    it 'should return two interfaces' do
      expect(scope.function_foreman_static_interfaces([]).keys.size).to eq(2)
    end

    it 'should return only matching interface' do
      expect(scope.function_foreman_static_interfaces(['Private']).keys.size).to eq(1)
    end
  end
end
