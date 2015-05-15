module Puppet::Parser::Functions
  newfunction(:hash_lookup, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|

    ENDHEREDOC

    # Validate the number of args
    if args.size != 2
      raise Puppet::ParseError, "hash_lookup(): wrong number of arguments (#{args.length}; must be exactly 2)"
    end

    hash = args[0]
    key = args[1]

    # Validate argument types
    unless hash.is_a?(Hash)
      raise Puppet::ParseError, "hash_lookup(): unexpected argument type #{hash.class}, first argument must be a hash"
    end
    unless key.is_a?(String)
      raise Puppet::ParseError, "hash_lookup(): unexpected argument type #{key.class}, second argument must be a string"
    end

    value = key.to_s.split('.').inject(hash) { |h,k| h[k] }
    value

  end
end
