const _ = require('lodash');

module.exports = (vnets, location, modules_dir) => {
  return _.map(vnets, (vnet, name) => {
    return _.map(vnet.testhost, (vm) => {
      return `
module "${name}-${vm.hostname}" {
  source                    = "${modules_dir}/testhost"
  location                  = "${location}"
  resource_group_name       = "${name}"
  vnet_subnet_id_vm         = "\${module.${name}.vnet_subnets[0]}"
  hostname                  = "${vm.hostname}"
  admin_username            = "${vm.username}"
  admin_password            = "${vm.password}"
  dns_name                  = "${vm.dnsname}"
}`
      })
  })
}
