# puppet-foreman_networking

[![Build Status](https://travis-ci.org/treydock/puppet-foreman_networking.svg?branch=master)](https://travis-ci.org/treydock/puppet-foreman_networking)

## Overview

Puppet module to convert Foreman ENC network interface data into values that can be passed into create_resources function.

## Usage

This following example uses the [razorsedge/network](https://forge.puppetlabs.com/razorsedge/network) module.

Here the value for all interfaces reported by Foreman are given an `ensure` value of `up` and a `mtu` of `1500`.

    $static_interface_defaults = {
      'ensure' => 'up',
      'mtu'    => '1500',
    }
    $static_interfaces = foreman_static_interfaces()
    create_resources('network::if::static', $static_interfaces, $static_interface_defaults)

