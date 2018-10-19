
# Azure Provider Variables
azure_subscription_id = ""
azure_client_id = ""
azure_client_secret = ""
azure_tenant_id = ""

# Global Vars
location = "east us2"

#Load Balancer Var
frontend_private_ip_address = "10.217.127.40"

#Main Vars
resource_group_name = "Stern-Test2"

#Spoke Vars
spoke_count = "2"
spoke_resource_group_name = ["Operations", "Security"]
spoke_address_space = ["192.168.3.0/24", "192.168.2.0/24"]
spoke_subnet_prefixes = ["192.168.3.0/25", "192.168.3.128/24", "192.168.2.0/25", "192.168.2.128/24"]
spoke_subnet_names = ["subA", "subAA", "subB", "subBB"]

# Routing
route_table_name = "Default"
route_name = "Default_RT"
next_hop_type = "VirtualAppliance"
#next_hop_ip= ""
address_prefix_route = "10.0.0.0/8"
