module Puppet::Parser::Functions
  newfunction(:foreman_static_interfaces, :type => :rvalue, :doc => <<-'ENDHEREDOC') do |args|

    ENDHEREDOC

    default_value_map = {
      'title'     => 'identifier',
      'ipaddress' => 'ip',
      'netmask'   => ['attrs.netmask', 'subnet.mask'],
      'gateway'   => 'subnet.gateway',
      'dns1'      => 'subnet.dns_primary',
      'dns2'      => 'subnet.dns_secondary',
      'mtu'       => 'attrs.mtu',
    }
    default_optional_values = [
      'gateway',
      'dns1',
      'dns2',
      'mtu',
    ]

    # Validate the number of args
    if args.size > 6
      raise Puppet::ParseError, "foreman_static_interfaces(): wrong number of arguments (#{args.length}; must be no more than 6)"
    end

    subnet_match = args[0] || ''
    managed_only = args[1] || true
    subnet_match_key = args[2] || 'subnet.name'
    interface_type_key = args[3] || 'type'
    value_map = args[4] || default_value_map
    optional_values = args[5] || default_optional_values

    # Validate argument types
    unless subnet_match.is_a?(String)
      raise Puppet::ParseError, "foreman_static_interfaces(): unexpected argument type #{subnet_match.class}, subnet argument must be a string"
    end
    unless !!managed_only == managed_only || managed_only !~ /^(true|false)$/
      raise Puppet::ParseError, "foreman_static_interfaces(): unexpected argument type #{managed_only.class}, managed only argument must be true or false"
    end
    unless subnet_match_key.is_a?(String)
      raise Puppet::ParseError, "foreman_static_interfaces(): unexpected argument type #{subnet_match_key.class}, subnet key argument must be a string"
    end
    unless interface_type_key.is_a?(String)
      raise Puppet::ParseError, "foreman_static_interfaces(): unexpected argument type #{interface_type_key.class}, interface type key argument must be a string"
    end
    unless value_map.is_a?(Hash)
      raise Puppet::ParseError, "foreman_static_interfaces(): unexpected argument type #{value_map.class}, value map argument must be a hash"
    end
    unless optional_values.is_a?(Array)
      raise Puppet::ParseError, "foreman_static_interfaces(): unexpected argument type #{optional_values.class}, optional values argument must be an array"
    end

    data = self.lookupvar('foreman_interfaces')
    return {} if data.nil? || data == :undef || data == :undefined

    interfaces = {}
    data.each do |d|
      # Only deal with Interface types
      next unless function_hash_lookup([d, interface_type_key]) == 'Interface'
      # Only deal with managed interfaces
      if managed_only.to_s == 'true'
        next unless function_hash_lookup([d, 'managed']).to_s == 'true'
      end
      # If a subnet match was defined, skip if subnet name does not match
      unless subnet_match == ''
        subnet_name = function_hash_lookup([d, subnet_match_key])
        next unless subnet_name == subnet_match
      end
      interface = {}
      value_map.each_pair do |key, map|
        value = nil
        next if key == 'title'
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
        # Handle optional values which may not be present
        if optional_values.include?(key)
          if value.nil? or value == ''
            next
          end
        end
        interface[key] = value
      end
      title = function_hash_lookup([d, value_map['title']])
      interfaces[title] = interface
    end

    interfaces
  end
end
