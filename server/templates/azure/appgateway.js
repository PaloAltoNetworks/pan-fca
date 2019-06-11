const _ = require('lodash');

module.exports = (vnets, location, modules_dir) => {
  return _.map(vnets, (vnet, name) => {
    const rg_name = vnet['vnet_network']['resource_group_name']? vnet['vnet_network']['resource_group_name']: name;
    return _.map(vnet.app_gateway, appgw => {
      return `
module "${name}" {
  source                    = "${modules_dir}/app_gateway"
  resource_group_name       = "${rg_name}"
  location                  = "${location}"
  app_gw_name               = "${appgw.name}"
  gw_ip_config_subnet_id    = "${module[name].vnet_subnets[3]}"
  backend_address_pool_name = "${appgw.Backend_Name}"
}`
    })
  })
}
