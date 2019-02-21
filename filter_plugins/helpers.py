from ansible import errors
import itertools

def item_to_list(string):
    #try:
    if True:
        if isinstance(string, basestring):
            return [string]
        else:
            return string
    #except Exception, e:
    #    raise errors.AnsibleFilterError('There was a issue converting string %s to a list of one"' % str(string) )

def my_magic_filter(data):
    output_dictionary= {}
    for item in data["modules"]:
        if item["outputs"].get("spoke_vpn_name", {}).get("value"):
            public_ip = item["outputs"].get("vgw_public_ips", {}).get("value")
            tunnel_ip = item["outputs"].get("vgw_tunnel_ips", {}).get("value")
            fw_tunnnel_ip = item["outputs"].get("fw_tunnel_ips", {}).get("value")
            tunnel_psk = item["outputs"].get("tunnel_psks", {}).get("value")
            spoke_vpn_name = item["outputs"].get("spoke_vpn_name", {}).get("value")
            firewall_ip = item["outputs"].get("spoke_firewalls", {}).get("value")
            firewall_id = item["outputs"].get("spoke_firewalls_ids", {}).get("value")

            if not output_dictionary.get(firewall_id):
                output_dictionary[firewall_id] = {"public_ip": public_ip, "tunnel_ip": tunnel_ip, "tunnel_psk":
                    tunnel_psk, "firewall_ip": firewall_ip, "fw_tunnel_ip": fw_tunnnel_ip, "spoke_vpn_name": spoke_vpn_name}
            else:
                output_dictionary[firewall_id]["public_ip"].extend(public_ip)
                output_dictionary[firewall_id]["tunnel_ip"].extend(tunnel_ip)
                output_dictionary[firewall_id]["tunnel_psk"].extend(tunnel_psk)
                output_dictionary[firewall_id]["fw_tunnel_ip"].extend(fw_tunnnel_ip)
    return output_dictionary

def collate_filter(panos_defaults, firewall_data, ansible_host):
    output = []
    for k in firewall_data.keys():
        if panos_defaults["filter"] == "gateway":
            if firewall_data[k]["firewall_ip"] == ansible_host:
                for index, item in enumerate(firewall_data[k].get("public_ip")):
                    combined_info = {}
                    for key, value in panos_defaults.items():
                        combined_info[key] = value
                    combined_info["public_ip"] = item
                    combined_info["name"] = k + str(index + 1)
                    combined_info["tunnel_ip"] = firewall_data[k].get("tunnel_ip")[int(index)]
                    combined_info["tunnel_psk"] = firewall_data[k].get("tunnel_psk")[int(index)]
                    output.append(combined_info)
        elif panos_defaults["filter"] == "tunnel":
            if firewall_data[k]["firewall_ip"] == ansible_host:
                for index, item in enumerate(firewall_data[k].get("fw_tunnel_ip")):
                    combined_info = {}
                    for key, value in panos_defaults.items():
                        combined_info[key] = value
                    combined_info["if_name"] = ("tunnel." + str(index + panos_defaults["begin_tunnel_number"]))
                    combined_info["fw_tunnel_ip"] = (item + panos_defaults["cidr_notation"])
                    output.append(combined_info)
        elif panos_defaults["filter"] == "ipsec":
            if firewall_data[k]["firewall_ip"] == ansible_host:
                for index, item in enumerate(firewall_data[k].get("fw_tunnel_ip")):
                    combined_info = {}
                    for key, value in panos_defaults.items():
                        combined_info[key] = value
                    combined_info["name"] = k + str(index + 1)
                    combined_info["if_name"] = ("tunnel." + str(index + panos_defaults["begin_tunnel_number"]))
                    combined_info["spoke_name"] = (panos_defaults["suffix"] + str(index))
                    output.append(combined_info)
    return output

# def merge_tunnel_info(ipsec_info, ike_info, tun_info, firewall_data, ansible_host):
#     output = []
#     for k in firewall_data.keys():
#         if firewall_data[k]["firewall_ip"] == ansible_host:
#             for index, item in enumerate(firewall_data[k].get("fw_tunnel_ip")):
#                 combined_info = {}
#                 for key, value in itertools.izip(ike_info.items(), tun_info.items(), ipsec_info.items()):
#                     combined_info[key] = value
#                 combined_info["name"] = k + str(index + 1)
#                 combined_info["spoke_name"] = (ipsec_info["suffix"] + str(index))
#                 combined_info["if_name"] = ("tunnel." + str(index + tun_info["begin_tunnel_number"]))
#                 output.append(combined_info)


class FilterModule(object):
    ''' A filter to split a string into a list. '''
    def filters(self):
        return {
            'item_to_list' : item_to_list,
            'my_magic_filter': my_magic_filter,
            'collate_filter': collate_filter,
            # 'merge_tunnel_info': merge_tunnel_info,
        }
