const _ = require('lodash');
const ifVarExist = require('../helper').ifVarExist;

module.exports = (vnets, location, modules_dir) => {

  return _.map(vnets, (vnet, name) => {
    const rg_name = vnet['vnet_network']['resource_group_name']? vnet['vnet_network']['resource_group_name']: name;
    return _.map(vnet['load_balancers'], lb => {
      const floating_ip = lb['floating_ip'] ? lb['floating_ip'] : ''
      return `      
module "${lb.name}" {
  source                                 = "${modules_dir}/loadbalancer"
  name                                   = "${lb.name}"
  location                               = "${location}"
  resource_group_name                    = "${rg_name}"
  type                                   = "${lb.type}"
  
  ${ifVarExist('floating_ip', lb.floating_ip, lb.floating_ip)}

  frontend_name                          = "${lb.frontendname}"
  backendpoolname                        = "${lb.backendname}"
  lb_probename                           = "${lb.lbprobename}"

  ${lb.type == 'private'?
    `frontend_subnet_id                     = "\${module.${name}.vnet_subnets[1]}" 
    ${ifVarExist('frontend_private_ip_address_allocation', lb.frontend_private_ip_address_allocation, lb.frontend_private_ip_address_allocation)}
    ${lb.frontend_private_ip_address_allocation == 'Static'? 
      `frontend_private_ip_address            = "${lb.static_IP}"`
      :
      `frontend_private_ip_address            = "\${cidrhost(module.${name}.vnet_subnet_prefixes[1], -3)}"`
    }
    `
  : ''
  }

  "lb_port" {
      ${lb.lbrulename}  = ["${lb.lbrulefrontendport}", "${lb.lbruleprotocol}", "${lb.lbrulebackendport}"]
  }

  "lb_probe_port" {
      ${lb.lbprobename} = ["${lb.lbrulehealthprobeport}"]
  }
}`
    }) 
  })
}
