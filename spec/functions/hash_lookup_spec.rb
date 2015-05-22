require 'spec_helper'

describe 'the hash_lookup function' do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  let(:hash) do
    {
      'foo' => 'bar',
      'nested-foo' => { 'test' => 'baz' },
    }
  end

  it 'should exist' do
    expect(Puppet::Parser::Functions.function('hash_lookup')).to eq('function_hash_lookup')
  end

  it 'should raise a ParseError no arguments passed' do
    expect { scope.function_hash_lookup([]).to raise_error(Puppet::ParseError) }
  end

  it 'should raise a ParseError only 1 argument passed' do
    expect { scope.function_hash_lookup([{}]).to raise_error(Puppet::ParseError) }
  end

  it 'should return value for simple lookup' do
    expect(scope.function_hash_lookup([hash, 'foo'])).to eq('bar')
  end

  it 'should return value for nested lookup' do
    expect(scope.function_hash_lookup([hash, 'nested-foo.test'])).to eq('baz')
  end

  it 'should handle no value' do
    expect(scope.function_hash_lookup([hash, 'foo1'])).to be_nil
  end

  it 'should handle no value for nested lookup' do
    expect(scope.function_hash_lookup([hash, 'nested-bar.test'])).to be_nil
  end
end
