require 'spec_helper'

describe 'foreman_networking' do
  on_supported_os({
    :supported_os => [
      {
        "operatingsystem" => "CentOS",
        "operatingsystemrelease" => [
          "6",
        ],
      }
    ],
  }).each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts.merge({
          :foreman_interfaces => fixture_data('single_interface.yaml')['foreman_interfaces']
        })
      end

      let(:pre_condition) do
        "
        $static_interfaces = foreman_static_interfaces()
        create_resources('network::if::static', $static_interfaces, {'ensure' => 'up'})
        "
      end

      it { should have_network__if__static_resource_count(1) }

      it "should create static interface eth0" do
        should contain_network__if__static('eth0')
      end
    end
  end
end
