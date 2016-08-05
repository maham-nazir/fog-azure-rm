module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def add_address_prefixes_in_virtual_network(resource_group_name, virtual_network_name, address_prefixes)
          Fog::Logger.debug "Adding Address Prefixes: #{address_prefixes.join(', ')} in Virtual Network: #{virtual_network_name}"
          virtual_network = get_virtual_network_object_for_add_address_prefixes!(resource_group_name, virtual_network_name, address_prefixes)
          virtual_network = create_or_update_vnet(resource_group_name, virtual_network_name, virtual_network)
          Fog::Logger.debug "Address Prefixes: #{address_prefixes.join(', ')} added successfully."
          Azure::ARM::Network::Models::VirtualNetwork.serialize_object(virtual_network)
        end

        private

        def get_virtual_network_object_for_add_address_prefixes!(resource_group_name, virtual_network_name, address_prefixes)
          virtual_network = get_vnet(resource_group_name, virtual_network_name)
          attached_address_prefixes = virtual_network.properties.address_space.address_prefixes
          virtual_network.properties.address_space.address_prefixes = attached_address_prefixes | address_prefixes
          virtual_network
        end
      end

      # Mock class for Network Request
      class Mock
        def add_address_prefixes_in_virtual_network(*)
          {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-rg/providers/Microsoft.Network/virtualNetworks/fog-vnet',
            'name' => 'fog-vnet',
            'type' => 'Microsoft.Network/virtualNetworks',
            'location' => 'westus',
            'properties' =>
              {
                'addressSpace' =>
                  {
                    'addressPrefixes' =>
                      [
                        '10.1.0.0/16',
                        '10.2.0.0/16'
                      ]
                  },
                'dhcpOptions' => {
                  'dnsServers' => [
                    '10.1.0.5',
                    '10.1.0.6'
                  ]
                },
                'subnets' =>
                  [
                    {
                      'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-rg/providers/Microsoft.Network/virtualNetworks/fog-vnet/subnets/fog-subnet',
                      'properties' =>
                        {
                          'addressPrefix' => '10.1.0.0/24',
                          'provisioningState' => 'Succeeded'
                        },
                      'name' => 'fog-subnet'
                    }
                  ],
                'resourceGuid' => 'c573f8e2-d916-493f-8b25-a681c31269ef',
                'provisioningState' => 'Succeeded'
              }
          }
        end
      end
    end
  end
end
