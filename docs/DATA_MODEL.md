# Data Model

Use Readme to define requirements for the the Data Model

Syntax to be known for describing the data model

    - `(*)` is required
    - The data types will be defined as [list, list_of_dict, dict]
    - The value types will be defined as [string, int, ip_addr, cidr]

# Configuration Management

## Virtual Router

* cm_virtual_router (list) - A list of virtual routers defined
    * name * (string)- The name of the virtual router you want to define

Defaults: None

Example:

```
cm_virtual_routers:
  - 'internal'
  - 'external'
```

## Interface

* cm_interface* (list_of_dicts) - A list of interfaces
    * name* (string) - actual interfaces name, generally 'ethernet1/X' or 'aggregate-ethernetX'
    * ip* (ip_addr) - The IP address of the interface
    * mask* (cidr) - Network mask of the interface
    * mgmt_profile (string)- The mgmt_profile applied to interface, must be created separately
    * virtual_router (string) - The name of the virtual router that the interface should be applied to
    * zone*: (string) The name of the zone to be applied, will be created separately

Defaults: virtual_router to default

Example:

```
cm_interface:
  - name: 'ethernet1/3'
    ip: '10.1.2.1'
    mask: '24'
    mgmt_profile: 'Allow Ping'
    virtual_router: 'untrust'
    zone: "trust"

  - name: 'ae1'
    ip: '10.1.3.1'
    mask: '24'
    mgmt_profile: 'Allow Ping'
    virtual_router: 'dmz'
    zone: "untrust"
```
## Address Objects

* cm_object_address (list_of_dicts) - List of address objects
    * name* (string) - Name of address object
    * ip (ip_addr) - IP and subnet mask of address object.
    * ip-range: (string) The IP range
    * fqdn: (string) The FQDN of the device

Example:

```
cm_object_address:
  - name: 'site-a-internal'
    ip-range: '10.1.1.0-10.1.2.255'
  - name: 'google-dns-1'
    ip: '8.8.8.8/32'
  - name: 'ip-chicken'
    ip: 'www.ipchicken.com'
```

## Address Groups

* cm_address_group (list_of_dict) - List of addresses and other address-groups
    * name* (string) - Name of address-group
    * addresses* (list) - Name of address objected already created

Example: 

```
cm_address_group:
  - name: 'google-dns'
    addresses:
     - 'google-dns-1'
     - 'ip-chicken'
```

### Service Objects

* cm_object_service (list_of_dict) - List of services defined
    * name* (string) - Name of Service object, referred to in service-group and policies
    * port* (int) - TCP/UDP port number
    * protocol* (string) - Either TCP or UDP

Example:

```
cm_object_service:
  - name: 'http-alt'
    port: '8000'
    protocol: 'tcp'
  - name: 'dns'
    port: '53'
    protocol: 'udp'
```

## Service Group Objects

* cm_object_service_group (list_of_dicts) - Groups of services either defined in services or pre-defined 
    * name* (string) - Name of service-group, can be referred to in policies or other service-groups
    * services* (list) - services or other service-groups defined

Example:

```
cm_object_service_group:
  - name: 'http-all'
    services:
     - 'http-alt'
     - 'service-http'
```
## Application Groups

- cm_object_app_group - List of Application Groups
    - name* (string) - Name of Group
    - apps* (list) - List of applications and application groups assigned to group.

Example:

```
cm_object_app_group:
  - name: 'ping-all'
    apps:
     - 'icmp'
     - 'ping'
```
> NOTE: Coming Soon!!!

## Dynamic Address Groups

* cm_object_dag - List of Dynamic Application Groups

> Note: TODO

Example:

```
cm_object_dag:
```
## Profile

* cm_object_profile - List of Profiles

> Note: TODO

Example:

```
cm_object_profile:
```
## NAT

* cm_nat_rule (list_of_dicts) - List of NAT rules
    * name* (string) - Name of NAT rule
    * tozone* (list) - List of Zones NAT can be sourced form
    * fromzone* (list) - List of Zones NAT can be destined for
    * source* (list) - List of address objects (address/address-groups) can be sourced from. Objects are created outside of this root key.
    * destination* - List of address objects (address/address-groups) can be destined for. Objects are created created outside of this root key..
    * service* (string) - Service object (service/service-group) that will be destined for
    * to_interface (string) - Interface where packet will leave
    * source_translation (dict) - Dict to describe the source translation
       * ip (ip_addr) - IP address to source from
       * ip_dynamic (list) - list of either IPs or objects
       * mask (cidr) - Mask of source
       * type (enum) - Either translated-address or the default interface-address
       * interface (string) - Interface for source
       * bidirectional (bool) - Whether or not the rule is bi-directional
    * destination_translation (dict) - Dict to describe the destination translation
       * translated_address (ip_addr) - Address object for translated address
       * port (port) - Address object for translated address


Example:

```
cm_nat_rule:
  - name: 'NAT default'
    tozone:
      - 'Untrust'
    fromzone:
      - 'Trust'
    source:
      - 'site-a-internal'
    destination:
      - 'any'
    service: 'any'
    source_translation:
      ip: '200.10.10.1'
      mask: '24'
      interface: 'ethernet1/1'
  - name: 'Inbound-NAT-to-DMZ-Server1'
    tozone:
      - 'Untrust'
    fromzone:
      - 'Untrust'
    source:
      - 'any'
    destination:
      - 'DMZ-Web-External'
    service: 'any'
    destination_translation:
      translated_address: 'DMZ-Web-Internal'
```

## Security Policy

* cm_security_rule (list_of_dict) - list of Security Rules applied to firewall
  * name* (string) - Name of Security rule, must be unique
  * action* (string) - either allow or deny
  * disabled* (boolean) - Rule can be disabled 'yes' or not 'no'
  * tozone* (list) - List of Zones that can be sourced
  * fromzone* (list) - List of Zones that can be destined for
  * source* (list) - List of Address objects, either address or address-group that are IP source
  * destination* (list) - List of Address objects, either address or address-group that are IP destinations
  * application* (list) - List of applications or application groups
  * tag* (list) - List of Tags, which must be defined in tags
  * category* (list) - List of URL categories 
  * source_user* (list) - List of Source Users
  * hip_profiles (list) - List of HIP profiles to be applied
  * rule_type (string) - Rule type can either be universal, intrazone, interzone

Example:

```
cm_security_rule:
  - name: 'Outside Web Server'
    action: 'allow'
    disabled: 'no'
    tozone:
      - 'Untrust'
    fromzone:
      - 'Trust'
    source:
      - 'site-a-internal'
    destination:
      - 'Outside-Web-Server'
    application:
      - 'any'
    service:
      - 'http-alt'
      - 'service-http'
    tags:
     - 'Outbound'
    category:
     - 'any'
    source_user:
     - 'any'
    hip_profiles:
     - 'any'
    rule_type: 'universal'
```

## Static Route

* cm_route_static (list_of_dict) - A list of static routes
    * name* (string) - Name of static route
    * nexthop* (ip_addr) - Nexthop IP of static route
    * network* (ip_addr) - Network id of static route
    * mask* (cidr) - Mask of static route
    * virtual_router (string) - The virtual router which will be applied to, generally 'default'
    * interface (string) - The interface to force nexthop out of

Defaults: virtual_router: default

Example:

```
cm_route_static:
  - name: 'Default-to-Internet'
    nexthop: '200.10.10.10'
    interface: 'ethernet1/1'
    network: '0.0.0.0'
    mask: '0'
    virtual_router: 'default'
```

## Management Profile

* cm_mgmt_profile (list_of_dict) - A list of Management profiles, which indicated which services are on, for a given interface
    * name* (string) - Name of profile, this will match mgmt_profile in 'device_network'
    * permitted_network (list) - List of IPs permitted using slash '/' format
    * telnet (bool) - Telnet service on or off
    * ssh (bool) - SSH service on or off
    * https (bool) - HTTPS service on or off
    * http (bool) - HTTP service on or off
    * snmp (bool) - SNMP service on or off
    * ping (bool) - Ping service on or off
    * response_pages (bool) - Response Page accessible via the applied interface
    * userid_service (bool) - userid_service service on or off
    * userid_syslog_listener_ssl (bool) - userid_syslog_listner_ssl service on or off
    * userid_syslog_listener_udp (bool) - userid_syslog_listner_udp service on or off

Defaults:
     - All Services default to off or none

Example:

```
cm_mgmt_profile:
  - name: 'allow ssh_https'
    permitted_network: 
        - 172.26.0.0/12
        - 10.0.0.0/8
    https: true
    ssh: true
``` 


##### DNS

cm_dns*:
* dns_primary* (ip_addr) - Primary DNS server, used by mgmt interface to reach out for updates
* dns_secondary* (ip_addr) - Secondary DNS Server

Example:

```
cm_dns:
  dns_primary: 8.8.8.8
  dns_secondary: 1.1.1.1
```


## NTP

cm_ntp*:
* ntp_primary* (ip_addr) - Primary NTP server, used by mgmt interface to reach out for updates
* ntp_secondary* (ip_addr) - Secondary NTP Server

Example:

```
cm_ntp:
  ntp_primary: 8.8.8.8
  ntp_secondary: 1.1.1.1
```

## Tunnel

* tunnels (list_of_dict) - A list of tunnels
    * name* (string) - Interface name of tunnel, e.g. loopback.1
    * ip (ip_addr) - IP address of tunnel
    * virtual_router (string) - Virtual Router name
    * profile (string) - interface management profile of device

Example:

```
tunnels:
  - name: 'tunnel.1'
    comment: 'SSL VPN Tunnel'
    virtual_router: 'default'
  - name: 'tunnel.2'
    ip: '10.10.10.20/32'
    profile: 'Allow Ping'
    virtual_router: 'default'

```

## Panorama

cm_panorama*:
* ntp_primary* (ip_addr) - Primary NTP server, used by mgmt interface to reach out for updates
* ntp_secondary* (ip_addr) - Secondary NTP Server

Example:

```
cm_ntp:
  ntp_primary: 8.8.8.8
  ntp_secondary: 1.1.1.1
```

## Router BGP

* cm_route_bgp (list_of_dict) - The BGP configuration
  * asn* (int) - The BGP ASN of the local ASN
  * install_route (bool) - Boolean to determine whether or not you install the routes
  * reject_def_route (bool) - Boolean to determine whether or not you install the routes
  * local_med_pref (int) - Integer that defines the local med
  * router_id* (ip_addr) - The IP address of the router ID
  * neighbor_group* (list_of_dict) - Method to describe Neighbor Groups
    * name* (string) - The name of the neighbor group
    * asn* (int) - Integer of the neighbor you are peering with
  * neighbors (list_of_dict) - 
    * remote_ip* (ip_addr) - IP address of the remote peer
    * bgp_group* (string) - Name of the BGP group this is associated with
    * description* (string) - Free form description of the the neighbor 
    * local_interface (string) - Interface name that bgp peer will connect on
  * bgp_rules: (string) - List of dicts to describe the export rules
    * name: (sting) - The name of the rule
    * type (enum) - Either import or export
    * enable (bool) - Whether or not the rule is enabled
    * neighbor_group (string) - The name of the neighbor group that is being used
    * add_pref_match (string) - IP address and subnet of the address
    * med (int) - Integer of the MED value
   * redist_rules (list_of_dict) - The 
    allow_def_route: True
    - redist_rule: "SomeRedistProfile"

Example:

```
router_bgp:
  asn: "65001"
  install_route: "yes"
  reject_def_route: "yes"
  local_med_pref: "100"
  router_id: "1.1.1.1"
  neighbor_group:
    - name: "AntonTest"
      asn: "65000"
  neighbors:
    - remote_ip: "169.254.50.39/30"
      bgp_group: "AntonTest"
      description: "Peer1"
      local_interface: "tunnel.1"
    - remote_ip: "169.254.51.39/30"
      bgp_group: "AntonTest"
      description: "Peer2"
      local_interface: "tunnel.2"
  export_rules:
    - name: "SomeExportRule"
      type: "export"
      enable: True
      neighbor_group: "AntonTest"
      add_pref_match: "0.0.0.0/0"
      med: "100"
    - name: "SomeImportRule"
      type: "import"
      enable: True
      neighbor_group: "AntonTest"
      add_pref_match: "10.10.10.10/24"
  #redist_rules:
  #  allow_def_route: True
  #  - redist_rule: "SomeRedistProfile"
```

## Users

* cm_users (list_of_dict) - List of firewall users
    * username* (string) - Username to be deployed to server
    * password* (string) - Password in hash format of user
    * role* (string) - Name of the role

Default to super user 

Example:

```
fw_users:
  - username: ''
    password: 'TheBestPassword'
  - username: 'ntc'
    password: 'TheSecondBestPassword'
```
## Licenses

* cm_license: (list) - List of auth keys
  * Licenses

```
cm_license:
  - 1234567
  - 0987654
```

## Iron Skillet

TODO

## IPSEC

TODO
  
## LDAP

TODO


#  Terraform:

## Provider

* tf_provider (dict) - List of credentials and provider information
  * name* (enum) - Either aws or azure
  * credentials* (string) - Credentials for the provider

Example:

```
provider:
  name: azure
  credentials: supersecretpassword

```

## Virtual Network Definitions

* virtual_networks* (list) - List of virtual networks to be deployed

> Note: This is only the defintion, the actual virtual networks are maintained in folder `virtual_networks` under individual files, e.g. `VPCTransit.yml` or `Spoke1.yml`.


Example:
```
virtual_networks:
  - VPCTransit
  - Spoke1
  - Spoke2
```

# Virtual Network Specific Parameters

## Firewalls

* firewalls (list_of_dicts) - Describing the name and amount of firewalls
  * name (string) - The name of the firewall (Not to be confused with hostname configured on fw)
  * networks (list) - list of named subnets, which are further defined in virtual_network_subnets
  * lb_join (list_of_dicts) - List of dictionaries describing when a LB should be joined to an interface
    * lb (string) - Name of the Load Balancer
    * network (string) - Name of the Network

Example: 

```
firewalls:
  - name: public_firewall
    networks:
      - Management
      - Trust
      - Untrust
      - EgressLB
    lb_join:
      - lb: public
        network: EgressLB
  - name: private_firewall
    networks:
      - Management
      - Trust
```

## Load Balancers

* load_balancers (list_of_dicts) - List of descriptions of load balancers
  * name (string) - Name of the load balancer
  * networks (list) - list of named subnets, which are further defined in virtual_network_subnets

Example:

```
load_balancers:
  - name: public
    networks:
      - Management
      - Untrust
      - extranet
      - dmz

  - name: private
    networks:
      - Trust
```
## Type

* type: transit

> Note: Should be removed long term

## IP Networks

* vnet_network (dict) - The definition of all IP networks
  * name (string) - The name of the virtual network
  * network (ip_addr) - The defined super-net of the virtual network
  * subnets (list_of_dicts) - The list of subnet information
    * name (string) - The name of the subnet
    * network (ip_addr) - The network assigned
    * rte (string) - The name of the routing table associated with

Example:

```
vnet_network:
  name: mainvnet
  network: "10.217.127.0/24"
  subnet:
  - name: Management
    network: "10.217.127.64/27"
    rte: Default_RT
  - name: Trust
    network: "10.217.127.32/27"
    rte: internal_network`
  - name: Untrust
    network: "10.217.127.0/27"
    rte: default_internet
  - name: EgressLB
    network: "10.217.127.96/27"
    rte: default_internet
```

## Route

* route (list_of_dicts) - The description of your list of networks
  * cidr (ip_addr) - The ip and subnet mask of the destionation route
  * name (sting) - The named entity of the object
  * gateway (string) - Either the subnet, igw, vgw, cgw, natgw, or virtual_appliance of the next hop

```
route:
  - cidr: 0.0.0.0/0
    name: default_internet
    gateway: my_igw
  - cidr: 0.0.0.0/0
    name: azure_default_internet
    gateway: Default_RT
  - cidr: 10.0.0.0/8
    name: internal_network
    gateway: 10.1.1.1
```

## Security Groups

* security_groups (list_of_dicts) - The list of security groups
  * name (string) - The name of the security group
  * priority (integer) - The priority of the group
  * direction (enum) - Inbound or outbound
  * action (enum) - Allow or Deny
  * src_ip (ip_addr) - The Source IP address
  * src_port (string) - The port or port range
  * dst_port (string) - The port or port range
  * dst_ip (ip_addr) - The destination IP of the rule
  * protocol (string) - The IP level protocol 

Example:

# Rule Order is determined by space
```
security_groups:
  - name: Outbound allow
    priority: 100
    direction: inbound
    action: allow
    src_ip: 0.0.0.0
    src_port: any
    dst_port: any
    dst_network: 0.0.0.0.
    protocol: any
```

## Gateways

### Internet Gateway

* internet_gw (list) - List of Internet Gateways

Example:

```
internet_gw:
  - isp1
  - isp2
```

### Virtual Gateway

* virtual_gw (list) - List of Virtual Gateways

Example:

```
customer_gw:
  - cgw1
  - cgw2
```

### Customer Gateway

* customer_gw (list) - List of Customer Gateways

Example:

```
customer_gw:
  - cgw1
  - cgw2
```

##  Tags

* tags (list_of_dicts) - List of dicts that are used 
  * name (string) - Name of the tag
  * value (string) - Value of the tag

Example:

```
tags:
  - name: "environment"
    value: "dev"
  - name: "costcenter"
    value: "it"
````

## VPN

* vpn:
  * name:
  * vgw:
  * cgw:
  * asn:
  * routing:
    * dynamic:
    * static:
  * tunnels:
    * cidr:
    * preshared:

```
vpn:
  name:
  vgw:
  cgw:
  asn:
  routing:
    dynamic:
    static:
      - something
  tunnels:
    - cidr:
      preshared:
```

## BGP

BGP:
  asn:

## NAT

> TODO
nat_gw:
  subnet:
  elastic_ip:
