#!/usr/bin/env python

#  Copyright 2018 Palo Alto Networks, Inc
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

ANSIBLE_METADATA = {'metadata_version': '1.1',
                    'status': ['preview'],
                    'supported_by': 'community'}

DOCUMENTATION = '''
---
module: panos_ipsec_config
short_description: Create an ipsec tunnel and IKE gateway on the device.
description:
    - Create static routes on PAN-OS devices.
author: "Anton Coleman (@ancoleman)"
version_added: "2.6"
requirements:
    - pan-python can be obtained from PyPi U(https://pypi.python.org/pypi/pan-python)
    - pandevice can be obtained from PyPi U(https://pypi.python.org/pypi/pandevice)
notes:
    - Panorama is not supported.
    - IPv6 is not supported.
options:
    ip_address:
        description:
            - IP address or hostname of PAN-OS device.
        required: true
    username:
        description:
            - Username for authentication for PAN-OS device.  Optional if I(api_key) is used.
        default: 'admin'
    password:
        description:
            - Password for authentication for PAN-OS device.  Optional if I(api_key) is used.
    api_key:
        description:
            - API key to be used instead of I(username) and I(password).
    name:
        description:
            - Name of the virtual router.
        required: true
    state:
        description:
            - Create or remove static route.
        choices: ['present', 'absent']
        default: 'present'
'''

EXAMPLES = '''
panos_ipsec_config:
    ip_address: '{{ fw_ip_address }}'
    username: '{{ fw_username }}'
    password: '{{ fw_password }}'
    name : 'my-ipsec-tun1'
    tunnel_interface : 'tunnel.700'
    type : 'auto-key'
    ak_ike_gateway : 'yomomma'
    ak_ipsec_crypto_profile : ''
    tunnel_monitor_profile : ''
    tunnel_monitor_proxy_id : ''
    tunnel_monitor_dest_ip : ''
    ikegwname : 'yomomma'
    version : 'ikev1'
    peer_ip_type : 'ip'
    peer_ip_value  : '6.6.6.6'
    local_ip_address_type : 'ip'
    local_ip_address : None
    auth_type : 'pre-shared-key'
    pre_shared_key : None
    local_id_type : None
    local_id_value : None
    peer_id_type : None
    peer_id_value : None
    enable_passive_mode : False
    enable_nat_traversal : False
    enable_fragmentation : False
    ikev1_exchange_mode : 'auto'
    ikev1_crypto_profile : 'pan-cloud-ike-profile'
    enable_dead_peer_detection : True
    dead_peer_detection_interval : '10'
    dead_peer_detection_retry : '3'
    ikev2_crypto_profile : 'pan-cloud-ike-profile'
    ikev2_send_peer_id : False
    enable_liveness_check : False
    liveness_check_interval : '5'    
    state: 'present'
'''

RETURN = '''
# Default return values
'''

from ansible.module_utils.basic import AnsibleModule

try:
    from pandevice import base
    from pandevice import firewall
    from pandevice import panorama
    from pandevice import network
    from pandevice.panorama import Template
    from pandevice.errors import PanDeviceError
    import itertools

    HAS_LIB = True
except ImportError:
    HAS_LIB = False


def find_object(device, obj_name, obj_type):
    obj_type.refreshall(device)

    if isinstance(device, firewall.Firewall):
        return device.find(obj_name, obj_type)
    else:
        return None


def main():
    argument_spec = dict(
        ip_address=dict(required=True),
        username=dict(default='admin'),
        password=dict(no_log=True),
        api_key=dict(no_log=True),
        name=dict(type='str', required=True),
        ak_ipsec_crypto_profile=dict(type='str', required=False),
        ak_ike_gateway=dict(type='str',required=False),
        tun_type=dict(type='str', required=False),
        tunnel_interface=dict(type='str', required=False),
        devicegroup=dict(type='str', required=False),
        panorama_template=dict(),
        interface=dict(type='str', required=False),
        ikegwname=dict(type='str', required=False),
        version=dict(type='str', required=False),
        peer_ip_type=dict(type='str', required=False),
        peer_ip_value=dict(type='str', required=False),
        local_ip_address_type=dict(type='str', required=False),
        local_ip_address=dict(type='str', required=False),
        auth_type=dict(type='str', required=False),
        pre_shared_key=dict(type='str', required=False),
        enable_passive_mode=dict(type='bool', required=False),
        enable_nat_traversal=dict(type='bool', required=False),
        ikev1_exchange_mode=dict(type='str', required=False),
        ikev1_crypto_profile=dict(type='str', required=False),
        enable_dead_peer_detection=dict(type='bool', required=False),
        enable_fragmentation=dict(type='bool', required=False),
        dead_peer_detection_interval=dict(type='int', required=False),
        dead_peer_detection_retry=dict(type='int', required=False),
        state=dict(default='present', choices=['present', 'absent'])
    )

    '''
    tunnel_together = [['name','ak_ipsec_crypto_profile', 'ak_ike_gateway','tun_type','tunnel_interface']]

    ipsec_together = [['interface','ikegwname','version','peer_ip_type','peer_ip_value','local_ip_address_type',
                       'auth_type','pre_shared_key','','','','']]
    '''
    '''
    checkver = AnsibleModule(argument_spec=argument_spec, supports_check_mode=False)
    version = checkver.params['version']
    if version == 'ikev1':
        ike_elements = [['ikev1_exchange_mode','ikev1_crypto_profile']]
    if ike_elements:
    #    ikev1_mod = AnsibleModule(argument_spec=argument_spec, supports_check_mode=False, required_one_of=ike_elements)
    #else:
    '''

    module = AnsibleModule(argument_spec=argument_spec, supports_check_mode=False,
                           required_one_of=[['api_key', 'password']])

    if not HAS_LIB:
        module.fail_json(msg='pan-python and pandevice are required for this module.')

    name = module.params['name']
    ak_ipsec_crypto_profile = module.params['ak_ipsec_crypto_profile']
    ak_ike_gateway = module.params['ak_ike_gateway']
    tun_type = module.params['tun_type']
    tunnel_interface = module.params['tunnel_interface']
    ip_address = module.params['ip_address']
    username = module.params['username']
    password = module.params['password']
    api_key = module.params['api_key']
    devicegroup = module.params['devicegroup']
    interface = module.params['interface']
    ikegwname = module.params['ikegwname']
    version = module.params['version']
    peer_ip_type = module.params['peer_ip_type']
    peer_ip_value = module.params['peer_ip_value']
    local_ip_address_type = module.params['local_ip_address_type']
    local_ip_address = module.params['local_ip_address']
    #local_id_type = module.params['local_id_type']
    #local_id_value = module.params['local_id_value']
    #peer_id_type = module.params['peer_id_type']
    #peer_id_value = module.params['peer_id_value']
    auth_type = module.params['auth_type']
    pre_shared_key = module.params['pre_shared_key']
    enable_passive_mode = module.params['enable_passive_mode']
    enable_nat_traversal = module.params['enable_nat_traversal']
    enable_fragmentation = module.params['enable_fragmentation']
    ikev1_exchange_mode = module.params['ikev1_exchange_mode']
    ikev1_crypto_profile = module.params['ikev1_crypto_profile']
    enable_dead_peer_detection = module.params['enable_dead_peer_detection']
    dead_peer_detection_interval = module.params['dead_peer_detection_interval']
    dead_peer_detection_retry = module.params['dead_peer_detection_retry']
    #ikev2_crypto_profile = module.params['ikev2_crypto_profile']
    #ikev2_send_peer_id = module.params['ikev2_send_peer_id']
    #enable_liveness_check = module.params['enable_liveness_check']
    #liveness_check_interval = module.params['liveness_check_interval']
    state = module.params['state']

    changed = False

    try:
        device = base.PanDevice.create_from_device(ip_address, username, password, api_key=api_key)

        dev_group = None
        if devicegroup and isinstance(device, panorama.Panorama):
            dev_group = get_devicegroup(device, devicegroup)
            if dev_group:
                device.add(dev_group)
            else:
                module.fail_json(msg='\'%s\' device group not found in Panorama. Is the name correct?' % devicegroup)

        active_tunnels = network.IpsecTunnel.refreshall(device)
        active_gateways = network.IkeGateway.refreshall(device)

        found = False 
        for current_gw,current_tun in itertools.izip(active_gateways,active_tunnels):
            if current_tun.name == name:
                found = True
                del_obj0 =  current_tun
            if current_gw.name == ikegwname:
                found = True
                del_obj1 = current_gw
                break

        # only change when present, and does not already exist
        if state == 'present' and not found:
            changed = True
            if ikegwname:
                ikeGw = network.IkeGateway(interface=interface, name=ikegwname, version=version, peer_ip_type=peer_ip_type,
                                 peer_ip_value=peer_ip_value,local_ip_address=local_ip_address,
                                 local_ip_address_type=local_ip_address_type,
                                 auth_type=auth_type, pre_shared_key=pre_shared_key,
                                 enable_passive_mode=enable_passive_mode, enable_nat_traversal=enable_nat_traversal,
                                 enable_fragmentation=enable_fragmentation, ikev1_exchange_mode=ikev1_exchange_mode,
                                 ikev1_crypto_profile=ikev1_crypto_profile,
                                 enable_dead_peer_detection=enable_dead_peer_detection,
                                 dead_peer_detection_interval=dead_peer_detection_interval,
                                 dead_peer_detection_retry=dead_peer_detection_retry,
                                 )
                device.add(ikeGw)
                ikeGw.create()
            if name:
                ipsecTun = network.IpsecTunnel(name=name, tunnel_interface=tunnel_interface, type=tun_type,
                                     ak_ike_gateway=ak_ike_gateway,
                                     ak_ipsec_crypto_profile=ak_ipsec_crypto_profile)
                device.add(ipsecTun)
                ipsecTun.create()

        # only change when absent, and does already exist
        elif state == 'absent' and found:
            changed = True
            net_objs = [del_obj0,del_obj1]
            for net_obj in net_objs:
                device.add(net_obj)
                net_obj.delete()

    except PanDeviceError as e:
        module.fail_json(msg=e.message)

    module.exit_json(changed=changed)


if __name__ == '__main__':
    main()
