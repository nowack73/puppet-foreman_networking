module Puppet::Parser::Functions
  newfunction(:foreman_get_interface, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|

    ENDHEREDOC

    default_value_map = {
      'name'      => 'identifier',
      'ipaddress' => 'ip',
      'netmask'   => ['attrs.netmask', 'subnet.mask'],
      'gateway'   => 'subnet.gateway',
      'dns1'      => 'subnet.dns_primary',
      'dns2'      => 'subnet.dns_secondary',
      'mtu'       => 'attrs.mtu',
    }

    # Validate the number of args
    if args.size < 2
      raise Puppet::ParseError, "foreman_get_interface(): wrong number of arguments (#{args.length}; must be at least 2)"
    end
    if args.size > 4
      raise Puppet::ParseError, "foreman_get_interface(): wrong number of arguments (#{args.length}; must be no more than 4)"
    end

    match_key = args[0] || nil
    match_value = args[1] || nil
    managed_only = args[2] || false
    value_map = args[3] || default_value_map

    # Validate argument types
    if ! match_key.is_a?(String)
      raise Puppet::ParseError, "foreman_get_interface(): unexpected argument type #{match_key.class}, match key must be a string"
    end
    if ! match_value.is_a?(String)
      raise Puppet::ParseError, "foreman_get_interface(): unexpected argument type #{match_value.class}, match value must be a string"
    end
    unless !!managed_only == managed_only || managed_only !~ /^(true|false)$/
      raise Puppet::ParseError, "foreman_get_interface(): unexpected argument type #{managed_only.class}, managed only argument must be true or false"
    end
    unless value_map.is_a?(Hash)
      raise Puppet::ParseError, "foreman_get_interface(): unexpected argument type #{value_map.class}, value map argument must be a hash"
    end

    data = self.lookupvar('foreman_interfaces')
    return {} if data.nil? || data == :undef || data == :undefined

    interface = {}
    data.each do |d|
      # Match interface based on arguments provided
      matched_value = function_hash_lookup([d, match_key])
      next if match_value != matched_value
      # Only deal with managed interfaces
      if managed_only.to_s == 'true'
        next unless function_hash_lookup([d, 'managed']).to_s == 'true'
      end
      value_map.each_pair do |key, map|
        # Get value based on value map hash
        if map.is_a?(Array)
          map.each do |m|
            value = function_hash_lookup([d, m])
            unless value.nil? or value == ''
              break
            end
          end
        else
          value = function_hash_lookup([d, map])
        end
        interface[key] = value
      end
    end

    interface
  end
end
