require 'spec_helper'

describe 'the foreman_get_interface function' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('foreman_get_interface')).to eq('function_foreman_get_interface')
  end

  it 'should raise a ParseError with no arguments' do
    expect { scope.function_foreman_get_interface([]).to raise_error(Puppet::ParseError) }
  end

  it 'should raise a ParseError if first argument is not a string' do
    expect { scope.function_foreman_get_interface([{}]).to raise_error(Puppet::ParseError) }
  end

  context 'when foreman_interfaces is not defined' do
    it 'should return an empty hash' do
      expect(scope.function_foreman_get_interface(['subnet.network', '10.0.0.0'])).to eq({})
    end
  end

  context 'when foreman_interfaces contains interface data' do
    let(:foreman_interfaces) { fixture_data('single_interface.yaml')['foreman_interfaces'] }
    before(:each) do
      scope.stubs(:lookupvar).with('foreman_interfaces').returns(foreman_interfaces)
    end
  
    it 'should return hash' do
      expect(scope.function_foreman_get_interface(['subnet.network', '10.0.0.0'])).to be_a(Hash)
    end

    it 'should set interface title' do
      expected_name = foreman_interfaces.first['identifier']
      expect(scope.function_foreman_get_interface(['subnet.network', '10.0.0.0'])['name']).to eq(expected_name)
    end
  end

  context 'when foreman_interfaces multiple interfaces data' do
    let(:foreman_interfaces) { fixture_data('two_interfaces_different_subnets.yaml')['foreman_interfaces'] }
    before(:each) do
      scope.stubs(:lookupvar).with('foreman_interfaces').returns(foreman_interfaces)
    end
  
    it 'should return hash' do
      expect(scope.function_foreman_get_interface(['subnet.network', '10.0.0.0'])).to be_a(Hash)
    end

    it 'should set interface title' do
      expected_name = foreman_interfaces.first['identifier']
      expect(scope.function_foreman_get_interface(['subnet.network', '10.0.0.0'])['name']).to eq(expected_name)
    end
  end
end
